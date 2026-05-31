# Hong Kong Banking & Brokerage Direct Rules

本目录包含 Quantumult X 与 Shadowrocket 的香港银行/券商 App 分流规则，命中后全部走 `DIRECT`。

## 文件

- `quanx-hk-finance-direct.list`：Quantumult X 规则
- `shadowrocket-hk-finance-direct.conf`：Shadowrocket 规则片段

## 覆盖 App / 服务

- 众安银行 ZA Bank
- 天星银行 Airstar Bank
- 汇立银行 WeLab Bank
- 致富证券 Chief Securities
- 盈透证券 Interactive Brokers / IBKR
- 嘉信理财 Charles Schwab
- 蚂蚁银行 Ant Bank HK
- FSMOne / Fundsupermart
- BBAE
- 汇丰香港 HSBC HK
- 投资全速易 / i-Invest / AAStocks 相关

## 使用方式

### Quantumult X

在 `[filter_remote]` 引用：

```ini
https://raw.githubusercontent.com/<OWNER>/<REPO>/main/quanx-hk-finance-direct.list, tag=HK Finance Direct, force-policy=DIRECT, enabled=true
```

### Shadowrocket

在配置中直接复制 `shadowrocket-hk-finance-direct.conf` 的 `[Rule]` 内容，或作为远程规则引用（视 Shadowrocket 版本支持情况）。

## 说明

规则包含常见域名、关键字和 ASN/IP-CIDR 辅助项。金融类 App 域名会变动，如发现某 App 仍走代理，可通过抓包补充域名。
