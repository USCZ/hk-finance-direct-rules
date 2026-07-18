# 中国大陆用户的港美金融分流规则

本项目为 Shadowrocket、Quantumult X 和 Loon 提供香港 / 美国券商、香港银行及相关金融服务的分流规则。

最新逐项证据、拒绝收录项及客户端日志验证方法见 [`AUDIT.md`](AUDIT.md)。

## 分流原则

**默认 `DIRECT`，仅把明确需要非中国大陆 IP 的服务设为 `PROXY`。**

- 香港银行、虚拟银行、支付、交易所、监管机构和公开行情：`DIRECT`
- 美国 / 国际券商：默认 `DIRECT`
- 香港券商和财富平台：默认 `DIRECT`
- 已知会对中国大陆 IP 限制访问的跨境互联网券商：`PROXY`

当前 `PROXY` 例外清单：

| 类别 | 服务 |
| --- | --- |
| 跨境互联网券商 | 富途 / Futubull / moomoo |
| 跨境互联网券商 | 老虎证券 / Tiger Brokers / TradeUp |
| 跨境互联网券商 | 长桥 / Longbridge / Longport |
| 跨境互联网券商 | Webull |

除上述例外外，规则中收录的 IBKR、Schwab、Firstrade、Fidelity、E*Trade、Robinhood、耀才、辉立、华盛、uSmart、艾德、第一上海、海通国际、国泰君安国际、中银国际、FSMOne 等券商均为 `DIRECT`。如果以后确认某个服务必须使用香港或美国 IP，应补充精确域名并单独加入 `PROXY` 例外，而不是把整类海外金融机构全部代理。

## 文件

| 客户端 | 文件 | Raw 地址 |
| --- | --- | --- |
| Shadowrocket | `shadowrocket-hk-finance-direct.conf` | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/shadowrocket-hk-finance-direct.conf> |
| Quantumult X | `quanx-hk-finance-direct.list` | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/quanx-hk-finance-direct.list> |
| Loon | `loon-hk-finance-direct.list` | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/loon-hk-finance-direct.list> |

三份规则文件已经混合写好 `PROXY` / `DIRECT`，不要给整份远程规则强制套用单一策略。如果你的代理策略组不叫 `PROXY`，请将文件中的 `PROXY` 替换为自己的策略组名。

## 一键导入

### Shadowrocket

[导入 Shadowrocket](shadowrocket://config/add/https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fshadowrocket-hk-finance-direct.conf)

不同版本对远程配置片段的支持可能不同，最稳定的方式是把 `shadowrocket-hk-finance-direct.conf` 的 `[Rule]` 内容复制进当前配置。

### Quantumult X

[导入 Quantumult X](https://quantumult.app/x/open-app/add-resource?remote-resource=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fquanx-hk-finance-direct.list)

也可以在 `[filter_remote]` 中加入：

```ini
https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/quanx-hk-finance-direct.list, tag=HK US Finance Routing, update-interval=86400, opt-parser=false, enabled=true
```

不要添加 `force-policy=PROXY` 或 `force-policy=DIRECT`，否则会覆盖文件内的混合策略。

### Loon

[导入 Loon](https://www.nsloon.com/openloon/import?rules=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Floon-hk-finance-direct.list)

也可以在 `[Remote Rule]` 中加入：

```ini
https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/loon-hk-finance-direct.list, tag=HK US Finance Routing, enabled=true
```

## 致富证券 / Chief Securities

致富证券、Chief Trade 及其 Megahub 行情域名明确保持 `DIRECT`，并放在规则前部。若 App 仍提示 VPN，可能是它检测到 iOS 的 VPN / Network Extension 接口本身，而不是出口 IP；域名分流无法隐藏系统 VPN 状态。可使用路由器旁路代理、局域网透明代理，或在使用该 App 时关闭本机代理。

## 维护原则

1. 新增金融服务时先设为 `DIRECT`。
2. 只有在可复现地确认中国大陆 IP 被拒绝、且非账户或系统 VPN 检测问题时，才设为 `PROXY`。
3. 代理规则只使用品牌主域或明确后端域名，不使用 `DOMAIN-KEYWORD` 宽泛匹配，也不加入共享云服务域名和大段 IP-CIDR。
4. 如果 App 异常，先查看客户端日志中的实际域名，再补充最小范围规则。
5. 本规则应放在其他 Global、Proxy 或 Broker 大规则之前，以免精确的金融直连规则被提前覆盖。

## 免责声明

本项目仅用于网络分流规则研究和个人配置管理，不提供代理节点，也不构成投资建议、规避监管建议或服务可用性承诺。请遵守所在地法律法规、金融机构服务条款和监管要求。
