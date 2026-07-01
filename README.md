# HK / US Finance Routing Rules

面向 6 月 22 日后中国大陆网络环境下的香港、美国券商和香港银行 App 分流规则。

核心结论：

- 富途 / moomoo、老虎、长桥、Webull 等跨境互联网券商，以及 IBKR、Schwab、Firstrade 等美国券商，建议走海外代理 `PROXY`。
- 香港银行、虚拟银行、支付、交易所、监管机构和公开行情服务，默认保持 `DIRECT`。
- 致富证券 / Chief Securities（用户提到的“智富/致富证券”场景）在大陆区域不应默认走 VPN / 代理，本规则明确保持 `DIRECT`。
- 不默认加入大段腾讯云、AWS、阿里云 IP-CIDR。公开 `Broker.list` 里有这些增强段，但误伤面较大，本项目优先使用券商主域和明确后端域名。

规则只改变流量走向，不提供代理节点，也不保证任何券商服务可用。请遵守所在地法律法规、券商服务条款和监管要求。

## 文件

| 客户端 | 文件 | 语法 | Raw 地址 |
| --- | --- | --- | --- |
| Shadowrocket | `shadowrocket-hk-finance-direct.conf` | `[Rule]` 片段，`DOMAIN-*` | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/shadowrocket-hk-finance-direct.conf> |
| Quantumult X | `quanx-hk-finance-direct.list` | `HOST-*` 远程分流 | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/quanx-hk-finance-direct.list> |
| Loon | `loon-hk-finance-direct.list` | Surge / Loon `DOMAIN-*` 远程规则 | <https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/loon-hk-finance-direct.list> |

规则内已经写好 `PROXY` / `DIRECT`，不要在客户端里对整份规则再套统一策略，否则银行直连或券商代理会被覆盖。如果你的代理策略组不叫 `PROXY`，把三个文件里的 `PROXY` 批量替换成自己的策略组名。

## 致富证券 VPN 提示修复

致富证券 / Chief Securities 已做成“硬直连”：

- 致富相关规则放在三份规则文件最前面，优先于所有 `PROXY` 规则。
- 显式补齐 `api`、`api2`、`cas`、`toptrader`、`quote`、`service`、`speedweb`、`common-h5`、`chief-deposit` 等致富 App 子域。
- 显式补齐 Megahub 行情流：`charts`、`shield`、`xml`、`mtstreamer`、`mtprsstreamer`。
- 少量常见公网 IP / VPN 检测接口也走 `DIRECT`，减少“出口 IP 是代理”导致的误报。

配置时必须注意：

1. 把本规则放在其他 Global、Proxy、Broker、港股券商大规则之前。
2. Quantumult X 不要写 `force-policy=PROXY` 或 `force-policy=DIRECT`。
3. Shadowrocket 不要用 `RULE-SET,URL,PROXY` 包整份文件；直接导入/复制本仓库的 `[Rule]` 内容。
4. Loon 不要给整份远程规则套统一策略。
5. 修改后重载配置，关闭致富 App 后重新打开；必要时切一次飞行模式清掉长连接。

如果这样仍提示 VPN，原因通常不是域名分流，而是 App 在 iOS 上检测到了系统 VPN / Network Extension 接口本身。iOS 的 Shadowrocket、Quantumult X、Loon 即使某条规则是 `DIRECT`，连接仍会经过本机 VPN 扩展接管；能检测 `utun`/VPN 状态的 App 仍可能提示。这个场景只能用路由器旁路代理、局域网透明代理、关掉代理 App 后使用致富，或在支持按 App 排除的系统/客户端上把致富 App 排除出 VPN。

## 一键导入

### Shadowrocket

[导入 Shadowrocket](shadowrocket://config/add/https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fshadowrocket-hk-finance-direct.conf)

如果无法唤起 App，在 Shadowrocket 配置的 `[Rule]` 段引用或复制 `shadowrocket-hk-finance-direct.conf` 内容。Shadowrocket 不同版本对远程规则片段的导入能力不完全一致，直接复制 `[Rule]` 最稳定。

```text
shadowrocket://config/add/https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fshadowrocket-hk-finance-direct.conf
```

### Quantumult X

[导入 Quantumult X](https://quantumult.app/x/open-app/add-resource?remote-resource=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fquanx-hk-finance-direct.list)

也可以在 `[filter_remote]` 中加入：

```ini
https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/quanx-hk-finance-direct.list, tag=HK US Finance Routing, update-interval=86400, opt-parser=false, enabled=true
```

URL Scheme：

```text
quantumult-x:///add-resource?remote-resource=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Fquanx-hk-finance-direct.list
```

### Loon

[导入 Loon](https://www.nsloon.com/openloon/import?rules=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Floon-hk-finance-direct.list)

也可以在 `[Remote Rule]` 中加入：

```ini
https://raw.githubusercontent.com/USCZ/hk-finance-direct-rules/main/loon-hk-finance-direct.list, tag=HK US Finance Routing, enabled=true
```

URL Scheme：

```text
loon://import?rules=https%3A%2F%2Fraw.githubusercontent.com%2FUSCZ%2Fhk-finance-direct-rules%2Fmain%2Floon-hk-finance-direct.list
```

## 分流结论

### 建议走 `PROXY`

这些 App 或服务符合“跨境券商、海外券商、港美股交易和登录接口”的特征，且公开规则和社区反馈集中指向海外代理更稳定：

| 类别 | 服务 |
| --- | --- |
| 中资跨境互联网券商 | 富途 / Futubull / moomoo、老虎 / Tiger、长桥 / Longbridge / Longport、Webull |
| 美国 / 国际券商 | IBKR、Schwab / TD Ameritrade / thinkorswim、Firstrade、Robinhood、Fidelity、E*Trade、Vanguard、tastytrade、Merrill、Morgan Stanley、SoFi、BBAE |
| 香港券商 / 财富平台 | 耀才、辉立 / POEMS、华盛、uSmart、艾德、第一上海、海通国际、国泰君安国际、中银国际、Monex BOOM、富邦证券、FSMOne / Fundsupermart / iFAST |

### 建议走 `DIRECT`

这些服务不属于本次“券商交易软件限制”的主要目标，且银行/支付风控通常更偏好本地稳定直连：

| 类别 | 服务 |
| --- | --- |
| 明确例外 | 致富证券 / Chief Securities / Chief Trade / Megahub |
| 虚拟银行 / 支付 | ZA、Airstar、WeLab、Mox、livi、PAOb、Fusion Bank、Ant Bank HK、AlipayHK、Octopus、JETCO |
| 香港主要银行 | HSBC、Hang Seng、BOCHK、Citi HK、Standard Chartered HK、DBS HK、BEA、Dah Sing、CMB Wing Lung、CNCBI、CCB Asia、Public Bank HK、OCBC HK、AEON、J.P. Morgan |
| 交易所 / 监管 / 公开行情 | HKEX、HKEXnews、HKMA、SFC、AAStocks、ETNet、i-Invest |

## 判断原则

1. 明确被公开规则库归入跨境券商的域名，优先走 `PROXY`。
2. 交易、登录、报价卡、OpenAPI、App 推送等券商后端域名跟随券商品牌走 `PROXY`。
3. 银行、支付、监管和公开行情默认走 `DIRECT`，避免触发额外风控。
4. 致富证券 / Chief Securities 作为用户明确指出的大陆直连例外，保持 `DIRECT`，不跟随“香港券商全部代理”的粗规则。
5. 不使用 `DOMAIN-KEYWORD,invest` 这类宽泛规则；它会误命中大量投资、新闻、银行页面。
6. 不默认加入公开 `Broker.list` 中的大段 IP-CIDR。需要增强时可自行加入，但要接受误代理云服务的风险。

## 公开来源和取舍

本次规则参考了以下公开材料，并按可信度筛选：

- 目标仓库当前版本：`USCZ/hk-finance-direct-rules` 原始规则为全 `DIRECT`，覆盖银行、IBKR、Schwab、Chief 等，但不满足“受限券商走代理”的新需求。
- 公开券商规则：`Arthur-vx/broker-rules` Raw `Broker.list`，标注作者 `MsMc`、仓库 `Allen2023/broker-rules`、更新时间 `2026-06-19`，覆盖富途、老虎、长桥、Webull、Schwab 及若干后端域名/IP。
- 大型规则库：`blackmatrix7/ios_rule_script` 的 Global 规则可侧面看到部分券商域名已经被社区归入全球代理规则，但它是通用代理规则，不能直接照搬为金融专项规则。
- 券商和银行官网主域：按服务品牌主域补齐 IBKR、Schwab、Firstrade、香港主要银行、虚拟银行和监管/交易所域名。
- 社区 / X / GitHub 讨论：只作为弱证据。仅凭单条帖子出现的域名不直接加入；只有和公开规则库、品牌主域或用户实测约束一致时才收录。

## 维护建议

- 如果某个券商 App 仍然直连失败，先在客户端日志里抓取被命中的域名，再补充精确 `DOMAIN` / `HOST`，不要先加宽泛关键词。
- 如果银行 App 出现风控或登录异常，确认它是否被上游代理规则覆盖；本项目里的银行规则应放在其他海外代理大规则之前。
- 如果使用 Loon / Shadowrocket 的策略组不是 `PROXY`，必须替换规则里的策略名，否则会出现“规则命中但策略不存在”。
- 如果需要使用 `Broker.list` 的 IP-CIDR 增强，建议单独建可选文件，不要和默认规则混在一起。

## 免责声明

本项目仅用于网络分流规则研究和个人配置管理，不构成投资建议、规避监管建议或服务可用性承诺。使用者应自行判断合规性、账户风险和券商条款后果。
