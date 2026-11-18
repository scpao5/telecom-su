# 电信光猫超级管理员密码获取

中国电信天邑 **TEWA-709V** 光猫（网关）全自动 `telecomadmin` 超级管理员密码获取脚本。

<img width="1280" height="1374" alt="1000372376" src="https://github.com/user-attachments/assets/8ab88361-94dd-427e-8569-4a76f02be5cd" />
目前对我来说可以正常使用


## 用法

```sh
chmod +x su.sh
./su.sh
```

运行前需已连接该光猫网络（默认网关 `192.168.1.1`）。

## 流程

1. **环境自检**：自动检测并安装 `curl` / `telnet` / `expect` / `base64`（支持 Termux `pkg` 与 `apt`）。
2. **型号识别**：读取 `http://192.168.1.1:8080/login.html`，匹配 `gatewayTypes` 或 `TEWA-xxx`；非 709V 会告警并继续尝试。
3. **读取 BaseMac**：请求 `/entelnet.cgi` 取 `BaseMac=(...)`。
4. **本地算号**：以 BaseMac 的十六进制字符做位运算 + 位移，映射到内置字符表，得出 SU 密码。
5. **开启 Telnet**：请求 `/entelnet.cgi?Verification_code=<SU密码>`，返回 `SUCCESS` 即开启。
6. **注入提取**：`expect` 自动登录 `telnetadmin`，`su` 后执行 `telecomadmin get`，抓取 `passwd=` 写入临时文件 `./.t`。
7. **登录校验**：取 `sessionKey`，Base64 编码密码后 POST `/login.cgi`，检查是否返回 `Set-Cookie: _sck=`，确认账号有效。

## 输出

校验通过后打印 `telecomadmin` 账号与密码，可浏览器登录 <http://192.168.1.1>。

## 说明

- 仅适用于自有设备，请勿用于未经授权的设备。
- 固件版本不同可能导致算法偏差；失败可尝试硬重启光猫后重试。
- 依赖 telnet 后门与 `entelnet.cgi` 验证机制，若厂商封堵则失效。
- 许可证：AGPL-3.0
