# Incoming

## Git Shenenigans

- `git worktree add ../path BRANCHNAME` BEWARE: WSL and WIN symlinks are incompatible
- `git remote add NAME URL`
- `git fetch REMOTENAME`
- `git checkout REMOTE/master`
- `git switch -c BRANCHNAME`
- `git branch --set-upstream-to=REMOTE/BRANCH BRANCHNAME`
- `git pull REMOTE BRANCH`
- `git push origin BRANCHNAME`
- `git push REMOTE HEAD:master`

## Kannens Notes

Wie gesagt würde ich ein Modulkonzept präferieren, in dem sich das
Praktikum aus verschiedenen Modulen zusammensetzt. Ein Modul wäre eine
in sich abgeschlossene, möglichst unabhängige, auch austauschbare,
thematische Einheit. Die Module könnten nach und nach erstellt werden,
so dass wir irgendwann ein Baukasten von Modulen haben, aus dem wir für
jedes Semester variabel auswählen. Vorteil wäre auch, dass wir einfach
und allmählich vom alten Konzept auf das neue migrieren könnten.

Thematisch bin ich ein Fan vom sogenannten Roten Faden, den ich mir im
Bereich der Netze in etwa so vorstellen könnte, dass die Studierenden am
Anfang ein lokales Netz aufbauen und es dann konfigurieren sowie
analysieren. Dann in einer zweiten Phase, würden sie das Netz um einen
Router erweitern bzw. die Anbindung an das Internet herstellen.
In diesen beiden Phasen lassen sich dann beliebige Module andocken wie:

Autokonfiguration (in der 1. und/ oder 2. Phase; zu verteilende
Parameter werden definiert und ein Server installiert und konfiguriert
für DHCP, DHCPv6 oder Router Advertisements),

Naming-Services (wie Autokonfiguration für DNS oder lokale Dienste)

Netzfunktionalität (Netzkomponenten wie Switche, Router, Adressierung
wie MAC-/IP-Adressen, Naming etc.), wie sie vergleichend in der
Virtualisierung oder Containerisierung funktioniert