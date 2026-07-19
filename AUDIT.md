# 规则全面审计记录

最后审计：2026-07-19

## 结论

本仓库坚持“默认 `DIRECT`，有明确技术证据才 `PROXY`”：

- 香港和美国银行、支付、交易所、监管、行情服务默认 `DIRECT`。
- 香港券商与未发现中国大陆网络阻断证据的美国 / 国际券商默认 `DIRECT`。
- 富途、老虎、长桥、Webull、Schwab、Firstrade 使用 `PROXY`；IBKR 仅国际主域 `interactivebrokers.com` 使用 `PROXY`，区域站和交易网关直连。
- `PROXY` 只使用品牌主域和明确后端域名；不加入共享统计、共享云域、大段 IP-CIDR 或宽泛代理关键词。

IBKR、Schwab、Firstrade 并非因为“美国券商”这一身份而代理，而是特定主域同时出现在当前 `gfwlist` 和 Blackmatrix7 Proxy 域列表中。策略按精确证据边界应用，不扩展到同品牌但未被收录的区域站或交易网关。

## 证据等级

| 等级 | 含义 | 能否单独决定策略 |
| --- | --- | --- |
| A | 机构官网、官方开发者页面或官方组织当前使用的域名 | 可确认归属，不能单独证明需要代理 |
| G | 两个独立且近期更新的 GFW / 中国大陆网络代理来源精确收录 | 可以列为 `PROXY` 例外 |
| R | 两个独立的近期券商专项规则库收录 | 可补域名；是否代理还需结合 G、日志或稳定实测 |
| C | 单一公共规则库、历史页面或无法打开的品牌风格域名 | 只能作为候选 |
| L | 客户端日志中实际出现，并能确认命中策略；有进程归因时证据最强 | 可补精确域；直连/代理切换结果可决定策略 |

公共规则库把域名放进“券商”分类，只证明域名属于券商，不代表必须代理。账户开户资格、居民身份限制也不等同于 IP 网络限制。

## 本轮互联网来源

| 来源 | 快照 | 审计用途 |
| --- | --- | --- |
| 各机构官网及当前页面引用 | 2026-07-18 至 2026-07-19 | 确认品牌主域和官网实际资源域 |
| `gfwlist/gfwlist` | 2026-07-18 (`58b31e9`) | 检查中国大陆网络层阻断候选 |
| `blackmatrix7/ios_rule_script` | 2026-07-17 (`c00517c`) | 与 gfwlist 交叉确认代理域；检查中国直连分类 |
| `v2fly/domain-list-community` | 2026-07-17 (`1ca72d5`) | 核对富途、长桥、Schwab、HSBC 品牌域 |
| `Arthur-vx/broker-rules` | 2026-06-19 (`b048341`) | 核对富途、老虎、长桥后端域名 |
| `LurnD/TradeRulesets` | 2026-07-01 (`d5bc590`) | 核对 IBKR、Schwab、Firstrade、Fidelity 等交易平台域名 |
| `LingJingMaster/Shadowrocket-Rules` | 2026-06-20 (`833fbda`) | 核对港股券商域名和香港节点实践 |
| `ZanwingMak/diversion-rules` | 2026-06-12 (`49a0a43`) | 核对中资、香港及海外券商的品牌/API 域名 |
| `zhx60403/hk-finance-app-rules` | 2026-06-12 (`f167466`) | 核对香港银行、致富、IBKR、Schwab 等域名 |
| `vtgpcmsvgs/rulemesh` | 2026-07-18 (`d7ab649`) | 核对香港券商品牌补充域名 |
| `realseanch/seanrocket` | 2026-07-13 (`b00dcfc`) | 交叉检查香港银行直连域名 |
| `iczrac/Filters-for-QuantumultX` 的 IBKR 主机清单 | 2024-05-08 (`d86a1cc`) | 区分国际门户、美欧网关、香港亚洲网关 `hdc1` 和中国网关 `mcgw1.ibllc.com.cn` |

## `PROXY` 例外审计

| 软件 / 服务 | 证据 | 结论 |
| --- | --- | --- |
| 富途 / Futubull / moomoo | A、G、R | `futunn.com` 等主域被 gfwlist 与 Blackmatrix7 同时精确收录；多个券商专项库补充交易、静态及备用域。加入品牌专用 `futuapi.com`、`futuhongkong.com`、`futuin.com`、`qtlcdn.com`，拒绝共享 Appsflyer、腾讯云 IM 和云 IP 段。 |
| 老虎证券 / Tiger / TradeUp | A、G、R | `itiger.com` 被两类 GFW 来源共同收录。补入官网区域域 `tigerbrokers.com.sg`、`tigerbrokers.com.au` 和品牌域 `tigersecurities.com`。 |
| 长桥 / Longbridge / Longport | A、G、R | `longbridge.com` / `longbridge.global` 被两类 GFW 来源共同收录。补入近期券商库中的 `longbridge.app`。 |
| Webull | A、R | 当前 GFW 双来源未精确收录 `webull.com`，但多个券商专项库及品牌资源共同显示其 App 使用独立境外后端；沿用用户场景中的代理例外，并补入 `webullapp.com`、`webullbroker.com`、`webulltrade.com`。证据强度低于 G 级服务。 |
| IBKR / Interactive Brokers | A、G、R | 只有国际主域 `interactivebrokers.com` 被 gfwlist 与 Blackmatrix7 同时精确收录，因此该域及子域走 `PROXY`。`ibkr.com`、`ibkr.com.cn`、香港和其他区域门户未被这两个来源精确收录，保持 `DIRECT`。TWS / IB Gateway 的 `ibllc.com`、中国网关 `ibllc.com.cn`（包括 `mcgw1`）以及香港亚洲网关 `hdc1` 均保持 `DIRECT`。 |
| Charles Schwab / TD Ameritrade / thinkorswim | A、G、R | `schwab.com` 同时被 gfwlist 与 Blackmatrix7 精确收录，改为 `PROXY`；补齐 `schwab.net`、`schwabapi.com`、`tos.mx`。 |
| Firstrade | A、G、R | `firstrade.com` 同时被 gfwlist 与 Blackmatrix7 精确收录，改为 `PROXY`；补入 `firstrade.net`、`firstrade.us`。 |

## 默认 `DIRECT` 券商审计

| 类别 | 服务和补充域名 | 结论 |
| --- | --- | --- |
| 致富证券 | Chief Trade、Megahub、`cm-chiefgroup.com`、`zft2000.com`、`zft2025.com`、`chieftrader1979.com`、`toptrader1979.com`、`cg1979.com` | 官网与历史客户端日志共同确认品牌域，全部硬直连。App 要求“关闭网络工具”可能是 iOS VPN / Network Extension 检测，域名规则无法隐藏系统接口。 |
| 其他美国券商 | Robinhood、Fidelity、E*Trade、Vanguard、tastytrade、Merrill、Morgan Stanley、SoFi、BBAE | 没有 G 级阻断证据，默认直连。补齐 Robinhood CDN/市场域、Fidelity / NetBenefits、Morgan Stanley 客户端域等。 |
| 新增美国 / 国际平台 | TradeStation、Alpaca、Saxo、eToro、IG、Trading 212、Plus500、Public | 专项库确认品牌域，但没有足够证据证明必须使用境外 IP，按原则加入 `DIRECT`。 |
| 香港互联网券商 | 华盛、uSmart、艾德 | 补齐 `vbkr.com`、`hstong.com`、`huashengtong.com`、`usmartglobal.com`、`usmartsg.com` 等品牌域，默认直连。 |
| 中资香港券商 | 国泰海通、海通国际、中银国际、中信香港、申万宏源、招商证券国际、广发香港、银河国际、华泰国际、光大国际、信达国际、中金、招银国际、交银国际、东方国际、兴证国际、国信香港、中泰国际 | 从中资券商专项库补齐精确品牌域；没有 G 级证据，统一直连。 |
| 香港本地券商 / 财富平台 | 耀才、辉立 / POEMS、复星财富、第一上海、Monex BOOM、富邦、FSMOne、胜利证券等 | 品牌域默认直连；不因某个公共配置把“券商组”绑定香港节点就推断所有机构必须代理。 |

## 银行、支付与公共金融服务

| 类别 | 策略与结论 |
| --- | --- |
| 香港虚拟银行 | ZA、Airstar、WeLab、Mox、livi、PAOb、Fusion Bank、Ant Bank HK 全部 `DIRECT`；ZA 官网资源域 `zaticdn.com`、`zajourney.com` 已覆盖。 |
| 香港主要银行 | HSBC、Hang Seng、BOCHK、Citi HK、Standard Chartered HK、DBS HK、BEA、Dah Sing、CMB Wing Lung、CNCBI、CCB Asia、Public Bank HK、OCBC HK 全部 `DIRECT`；补入 `cmbwinglungbank.com`。 |
| 美国主要银行 | Chase、Bank of America、Wells Fargo、Capital One、U.S. Bank、PNC、Citi 全部 `DIRECT`；官网 HTTPS 可达，且当前 GFW 双来源未精确收录其主域。 |
| 支付、监管和行情 | AlipayHK、Octopus、JETCO、HKEX、HKMA、SFC、AAStocks、ETNet、i-Invest 全部 `DIRECT`。 |

## 实际客户端日志

工作区中的 Shadowrocket 历史请求数据库覆盖 2026-05-25 至 2026-06-10。日志记录了域名、命中结果和策略，但没有进程名。

已用于规则的日志证据：

- 致富风格域名：`cm-chiefgroup.com`、`zft2000.com`、`zft2025.com`、`chieftrader1979.com`、`toptrader1979.com`、`cg1979.com`。
- 建行访问：`www.ccb.com`，因此保留 `ccb.com,DIRECT`。

历史日志包含并发应用流量，不能证明每条请求都由对应 App 发起。新日志应在清空记录后仅启动一个金融 App，并保留时间、域名、命中规则、最终策略和错误结果。

## 明确拒绝的候选项

| 域名 / 规则 | 原因 |
| --- | --- |
| `i-innvest.com` | 疑似拼写错误，无法建立与 i-Invest 的可靠官方关系。 |
| `za.group.com` | 与 ZA Bank 当前官网域名结构不一致，无法验证。 |
| `mybank.cn` | 属于中国内地网商银行，不是 Ant Bank HK。 |
| `moomoo.co.nz` | 审计时跳转到无关网站。 |
| `futnunn.com` | 仅见于单一衍生规则并疑似拼写变体，未达到收录门槛。 |
| `tigerfin.com` | 单一来源且当前 HTTPS 无法验证，暂不收录。 |
| Appsflyer、Google/第三方统计域 | 共享归因服务，不能归属于单一券商。 |
| `shortconn.im.qcloud.com` | 腾讯云共享 IM 域名，代理会影响其他应用。 |
| `appsflyersdk.com`、`jpush.cn` | 共享 SDK / 推送域，不能因金融 App 使用而整体分流。 |
| AWS、腾讯云、阿里云 IP-CIDR | 共享基础设施误伤范围大，且 IP 会变化。 |
| `DOMAIN-KEYWORD,*` 代理兜底 | 可能误命中无关域名；代理只接受精确域或品牌根域。 |

## 校验结果

运行：

```bash
ruby tools/verify_rules.rb
```

校验覆盖：

- Shadowrocket、Quantumult X、Loon 规则集合和策略完全一致。
- 每行语法合法，无重复规则。
- 不存在父子域策略冲突。
- 不存在代理关键词规则。
- 被明确拒绝的共享、错误和无关域名没有重新混入。

规则只能决定出口路径，不能绕过开户资格、居民身份、账户风控、App 对系统 VPN 接口的检测或金融机构服务条款。
