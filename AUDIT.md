# 规则审计记录

最后审计：2026-07-18

## 证据标准

每条规则按以下证据分级：

- A：机构官网当前页面直接引用，或机构官方开发者 / GitHub 组织使用。
- B：两个相互独立且近期更新的公共域名规则库收录，且域名仍归属对应品牌。
- C：单一公共规则库或历史页面收录，尚未获得实际 App 日志确认。
- L：用户设备日志实际出现，并能确认由对应 App 发起。

默认策略为 `DIRECT`。只有服务可复现地拒绝中国大陆 IP，才把其品牌域名设为 `PROXY`。共享 CDN、统计、云厂商 IP 段和宽泛关键词不因单一 App 而代理。

## 公开来源

| 来源 | 本次快照 | 用途 |
| --- | --- | --- |
| 各机构官网及其当前页面链接 | 2026-07-18 | 确认品牌主域和官网实际引用域名 |
| `v2fly/domain-list-community` | 2026-07-17 (`1ca72d5`) | 核对富途、长桥、Schwab、HSBC 等品牌域名 |
| `blackmatrix7/ios_rule_script` | 2026-07-17 (`c00517c`) | 交叉检查通用代理/直连归类，不直接继承策略 |
| `Arthur-vx/broker-rules` | 2026-06-19 (`b048341`) | 核对富途、老虎、长桥等券商后端域名 |
| `zhx60403/hk-finance-app-rules` | 2026-06-12 (`f167466`) | 核对香港银行、IBKR、Schwab、致富等金融域名 |
| `vtgpcmsvgs/rulemesh` | 2026-07-17 (`0bd8f08`) | 核对香港券商品牌补充域名 |

公共规则库只证明“有人收录此域名”，不自动证明必须代理。策略仍以中国大陆网络实测为准。

## 券商审计

| 服务 | 策略 | 证据 | 审计结论 |
| --- | --- | --- | --- |
| 致富证券 / Chief Trade / Megahub | `DIRECT` | A、B | 官网当前引用 `api2.chiefgroup.com.hk`、`common-h5.chiefgroup.com.hk`、`service.chiefgroup.com.hk`、`chieftrade.com` 等；现有品牌域和行情域保持直连。App 的“关闭网络工具”提示可能是系统 VPN 接口检测，域名直连无法隐藏该接口。 |
| 富途 / Futubull / moomoo | `PROXY` | A、B | 官网与近期公共库共同确认品牌主域。新增 `futuhk1.com`、`futuoa.com`、`futusg.com`、`futunnimg.com`、`futubull.com`、`futuie.com` 及已确认的 moomoo 区域域名。 |
| 老虎证券 / TradeUp | `PROXY` | A、B | 官网当前引用 `tigertrade.app`、`itigergrowtha.com`，与公共库现有老虎品牌域合并。 |
| 长桥 / Longport | `PROXY` | A、B | 官网当前使用 `longbridge.com`、`lbctrl.com`、`lbkrs.com`、`wbrks.com`；与 v2fly 和 Broker.list 一致。 |
| Webull | `PROXY` | A、B | 官网当前静态资源使用 `webullfintech.com`，补入品牌域；不加入共享云厂商网段。 |
| IBKR | `DIRECT` | A、B | 官网当前互链确认 `.com.hk`、`.com`、`.co.uk`、`.ca`、`.co.in`、`.co.jp`、`.com.au`、`.com.sg`、`.ie` 等官方区域域名；没有足够证据证明这些域名必须使用外国 IP。 |
| Charles Schwab / thinkorswim | `DIRECT` | A、B | 官方区域站与 v2fly 确认 `aboutschwab.com`、`schwab.com.sg` 等；公共库将其收录为券商域不等于必须代理。 |
| Firstrade、Robinhood、Fidelity、E*Trade、Vanguard、tastytrade、Merrill、Morgan Stanley、SoFi、BBAE | `DIRECT` | A/C | 品牌主域保持直连；尚无可复现的“中国大陆 IP 必须被拒绝”证据。需要日志才能确认 App 专用后端。 |
| 复星财富 / 复星证券 | `DIRECT` | A、B | 增补 `fotechwealth.com`、`fotechwealth.com.cn`、`fosunwealth.com`、`fosunhani.com`。 |
| 辉立 / POEMS | `DIRECT` | A、B | 增补 `phillipfunds.com.hk`、`cyberquote.com.hk`；不因香港区域规则库使用香港节点而改成代理。 |
| 其他香港券商与财富平台 | `DIRECT` | A/C | 耀才、华盛、uSmart、艾德、第一上海、海通国际、国泰君安国际、中银国际、Monex BOOM、富邦、FSMOne 等保持默认直连；待实际日志确认专用后端。 |

## 银行与支付审计

| 服务 | 策略 | 证据 | 审计结论 |
| --- | --- | --- | --- |
| ZA Bank | `DIRECT` | A、B | 官网当前使用 `za.group`、`zaticdn.com`、`zajourney.com`，后两项已补入。`za.group.com` 是可疑历史/错误项，不收录。 |
| Airstar、WeLab、Mox、livi、PAOb、Fusion Bank、Ant Bank HK | `DIRECT` | A/C | 品牌主域保持直连。`mybank.cn` 属于另一项内地银行服务，不作为 Ant Bank HK 域名加入。 |
| HSBC / Hang Seng | `DIRECT` | A、B | 官网确认现有香港域，并补入 `hsbc.net`、`hsbcinnovationbanking.com`。品牌域之外的 AXA、调查、标签管理等第三方域不纳入金融专项规则。 |
| BOCHK、Citi HK、Standard Chartered HK、DBS HK、BEA、Dah Sing、CMB Wing Lung、CNCBI、CCB Asia、Public Bank HK、OCBC HK | `DIRECT` | A/C | 官方品牌主域保持直连；尚无可靠证据要求外国 IP。 |
| AlipayHK、Octopus、JETCO | `DIRECT` | A/C | 支付服务默认直连，避免代理出口触发额外风控。 |

## 明确拒绝的候选项

| 域名 / 规则 | 原因 |
| --- | --- |
| `i-innvest.com` | 疑似拼写错误，无法建立与 i-Invest 的可靠官方关系。 |
| `za.group.com` | 与 ZA Bank 当前官网域名结构不一致，无法验证。 |
| `mybank.cn` | 属于中国内地网商银行，不是 Ant Bank HK 的品牌域。 |
| `moomoo.co.nz` | 审计时跳转到无关网站，不应作为 moomoo 代理域。 |
| `shortconn.im.qcloud.com` | 腾讯云共享域名，代理会影响非券商业务。 |
| AWS、腾讯云、阿里云大段 IP-CIDR | 共享基础设施误伤范围过大，且 IP 会变化。 |
| `DOMAIN-KEYWORD,*` 代理兜底 | 可能误命中不属于目标机构的域名；代理例外只使用精确域或品牌根域。 |

## 实际客户端日志：待完成

当前工作区未发现可用的 Shadowrocket、Quantumult X 或 Loon 请求日志。现有 plist、规则数据库和配置文件不能证明某次 App 启动实际访问了哪些域名。

请在规则置于其他 Global / Proxy / Broker 规则之前的前提下，分别完成以下测试：

1. 清空客户端最近请求记录。
2. 完全结束目标金融 App。
3. 打开 App，完成启动、登录页、行情页和交易页访问，但不要提交真实交易。
4. 导出或截图最近请求，至少保留：时间、域名、命中规则、最终策略、连接错误。
5. 对同一 App 分别测试：代理工具开启且命中本规则；代理工具完全关闭。

日志判定：

- 命中本规则且策略正确，但关闭代理工具后提示消失：优先判定为 VPN / Network Extension 检测，不新增域名。
- 出现未收录的品牌专用域名：核对归属后补入对应机构。
- 出现共享 CDN / 云服务域名：只有能证明该域名专用于该金融 App 时才加入。
- 直连连接被服务端按中国大陆 IP 拒绝，代理后稳定恢复：才将该机构的精确域名列为 `PROXY` 例外。

在获得至少一份真实启动日志前，本审计不能声称已经完成 L 级验证。
