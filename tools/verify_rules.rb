#!/usr/bin/env ruby
# frozen_string_literal: true

FILES = {
  "shadowrocket-hk-finance-direct.conf" => "DOMAIN",
  "loon-hk-finance-direct.list" => "DOMAIN",
  "quanx-hk-finance-direct.list" => "HOST"
}.freeze

ALLOWED_TYPES = %w[DOMAIN DOMAIN-SUFFIX DOMAIN-KEYWORD].freeze
ALLOWED_POLICIES = %w[DIRECT PROXY].freeze
REJECTED_VALUES = %w[
  i-innvest.com
  za.group.com
  mybank.cn
  moomoo.co.nz
  shortconn.im.qcloud.com
  appsflyersdk.com
  jpush.cn
].freeze

EXPECTED_POLICIES = {
  ["DOMAIN-SUFFIX", "interactivebrokers.com"] => "PROXY",
  ["DOMAIN-SUFFIX", "ibkr.com"] => "DIRECT",
  ["DOMAIN-SUFFIX", "ibkr.com.cn"] => "DIRECT",
  ["DOMAIN-SUFFIX", "ibllc.com"] => "DIRECT",
  ["DOMAIN-SUFFIX", "ibllc.com.cn"] => "DIRECT"
}.freeze

def parse_rules(path, prefix)
  rules = {}

  File.foreach(path).with_index(1) do |line, number|
    text = line.strip
    next if text.empty? || text.start_with?("#", "[")

    type, value, policy, *extra = text.split(",")
    unless type&.start_with?(prefix)
      abort "#{path}:#{number}: unexpected rule type #{type.inspect}"
    end

    normalized_type = type.sub(/^HOST/, "DOMAIN")
    unless ALLOWED_TYPES.include?(normalized_type) &&
           ALLOWED_POLICIES.include?(policy) && extra.empty?
      abort "#{path}:#{number}: invalid rule #{text.inspect}"
    end

    key = [normalized_type, value]
    abort "#{path}:#{number}: duplicate rule #{key.join(',')}" if rules.key?(key)

    rules[key] = policy
  end

  rules
end

sets = FILES.map { |path, prefix| [path, parse_rules(path, prefix)] }
reference_path, reference = sets.first

sets.drop(1).each do |path, rules|
  missing = reference.keys - rules.keys
  extra = rules.keys - reference.keys
  changed = reference.keys.select { |key| rules.key?(key) && rules[key] != reference[key] }
  next if missing.empty? && extra.empty? && changed.empty?

  warn "#{path} differs from #{reference_path}"
  warn "  missing: #{missing.inspect}" unless missing.empty?
  warn "  extra: #{extra.inspect}" unless extra.empty?
  warn "  policy changes: #{changed.inspect}" unless changed.empty?
  exit 1
end

REJECTED_VALUES.each do |value|
  hit = reference.keys.find { |(_, candidate)| candidate == value }
  abort "rejected value returned: #{value}" if hit
end

proxy_keywords = reference.select do |(type, _value), policy|
  type == "DOMAIN-KEYWORD" && policy == "PROXY"
end
abort "PROXY keyword rules are not allowed: #{proxy_keywords.keys.inspect}" unless proxy_keywords.empty?

EXPECTED_POLICIES.each do |key, expected|
  actual = reference[key]
  abort "expected #{key.join(',')}=#{expected}, got #{actual.inspect}" unless actual == expected
end

suffixes = reference.select { |(type, _), _| type == "DOMAIN-SUFFIX" }
suffixes.each do |(_type, child), child_policy|
  suffixes.each do |(_other_type, parent), parent_policy|
    next if child == parent || !child.end_with?(".#{parent}")
    next if child_policy == parent_policy

    abort "nested suffix policy conflict: #{child}=#{child_policy}, #{parent}=#{parent_policy}"
  end
end

proxy_count = reference.count { |_key, policy| policy == "PROXY" }
direct_count = reference.count { |_key, policy| policy == "DIRECT" }

puts "OK: #{reference.size} rules; PROXY=#{proxy_count}; DIRECT=#{direct_count}; clients=#{FILES.size}"
