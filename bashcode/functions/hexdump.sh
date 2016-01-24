#hexdump
alias "hexd-cus1"="hexdump -e '1/4 \"[offset:%_ax]) \"' -e '1/4 \"%08X <-> \"' -e '4/1 \"%_p \"' -e '\"\n\"'"
alias "hexd-cus2"="hexdump -e '\"%06_ax\"' -e '\" [sequential]-> \"' -e '4/1 \"%02X \"' -e '\" [uint32,hex]-> \"' -e '/4 \"%08X \"' -e '\" [sint32,dec]-> \"' -e '/4 \"%011i \n\"'"

