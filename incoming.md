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


## Meeting notes

Modernisation of network learning
Abstract from physical stack
Remove dependence to physical stack
Reproducible results and exercises
Students can learn on there own and @home and not only in lab

2nd Term Exercise Netze
- Praktikum 2;
- Praktikum 3 Ipv6 Discovery; heise.de maybe good, because not all have Ipv6
Maybe better to set up a VPN to lab? For ipv6 outside access


- Praktikum 4 Router building -> Good to not change
New Routing Exercises?
In general, new Exercises?

--> All exercises doable on each and every machine, no special scenario


4th Term Exercise Internetkommunikation
- TCP Exercises, Analyses of TCP protocol and streams
- HTTP Exercises -> In Containers? In Kubernetes?
--> Specialized use cases, good candidate for virtualization


Master term Servicemanagment in Netzen
- Complex ready scenario (K8s/Swarm) where the exercises use this ready scenario


## 2020/01/30
Begin meeting 11:00
- Does it make sense to create automated exercise for the master modules?
	- Basic setup
	- Same ground between exercise?
	- Master niveau is different from bachelor niveau: Masters should do it all on their onwn?
-
- Presentation of 2nd term Netze
- Topics of the lecture
- Potentials see above
- Presentation of 4th term Internetkommunikation
- Topics of the lecture
	- Potentials see above
- Discussion about potential good exercises for virtualisation
- Discussion about needed research: What do other labs do? How can we change the whole aspect of the practica?
- Discussion about this contract
- Project needs title
- More concrete what will be delivered
- Write more understandle for people with implicits
- Put Ms Kannen in CC
- Write Project Desc until 2020-02-10 11am
- End @12:45


------
- Open questions:
	- Is english really good? Who will correct? Can Leischner understand?

------
- Research start @2pm 09/02/2020 end @5pm
- Proposal writing start @10am end 11am, @1215 end @1310, @1330 end, 19/02/2020 1354
- 30 minutes train from cologne to bonn
- 6h tex recreation
-
-------
Protocol 21.02 Start 1410   End 1535
- Vorstellung von Research Ergebnissen
- Vorstellung
- New Concept of Netzte: disjunct modules
- no depedences between
- modules mix and match for each term and semester
- module template
- Example: Pratical 4 of Netze
- 2-4 SWS
- List of potential exercises of Netze via email to me
- List of potentials modules of Internetkommunikation via email
- Two practical modules -> instant useable
    - Ubuengsblatt
    - Musterloesung
    - Didatic concept
- New requirements for modules: Docker and more
    - How to enable new knowledge about docker etc. to students?
    - How to make it debuggable for docker
    - One req: installed software ? script for starting
    - Or installation sheets with instructions
    - Or introductory lesson about the tecs
- How to enable automatic grading into modules/virt environments?
- lit presentation for docs
- Open Source Github Creation
- Vagrant Interactive shell?
- Hashicorp Nomad for Packing of complete application state?
- Server for HTTP practicals are running -> check reponse

### 2020-05-14 1000

- We need it more than ever now
- Online-course will be the future
- Take now the exisiting material and digitalise it
- 2. BI Netze and 4. Internetkommunikaton
- Chemievorlesung die digital ablief
  - Virtuelle Fabrik, mit der die Studenten interagieren konnten
  - War die Zentral oder auf den Rechnern der Studenten?
- Virtuelles Labor auf Studentenrechner/Zentral -> XTerm.js?
- Fertig konfiguierte VSCode Umgebung?
- Varant Setups?
- Vagrant Setup Sharing?
- CTFs as inspiration / problem based learning
- Model exercises as Jupyter Notebooks ?
- InfluxDB exercises and modules - Monitoringsysteme
- Wo die Ergebnisse? Git / Im Container / Direkt
- Anforderungen fur die realen MOdule: Welche Maschinen mussen stehen, welche VMs brauchen die studenten etc.
- Was soll das MP machen?
  - MP: Soll direkt in MA verwendet werden
  - MP: CTFs/Problem-based-learning an drei Baustellen austesten -> Module erstellen
  - 1: Email PDF als CTF Module (Jupyter Notebook?) -> MVP?
  - 2: (ab 4.) Use bachelor lecture "Monitoring Systems" and create CTF Modul: Grafana, Docker, Telegraf (what goal?)
    - How to let student access the whole system -> VPN Access (Wireshark?)
    - How many CPU RAM etc needs a CTF challange
    - Only IPv6? Can Docker Swarm/Kubernetes etc. be used with IPv6?
    - Get data directly from the cloud and make time inlfux data
  - 3: Servicemanagment in Netzen Master, CTF modul -> Vagrant/Server/What do students should learn?
- MA:
  - TheoreticaL: What are the didactics? What are the results of this learning method?
- Next Meeting: Proposal and scope declaration

### 2020-05-26  1115

- Concretise the three points from last week into the expected result
- Instead of 3rd Person author use mine
- Vorstellung Gleb erste Research Ergebnisse
- Wie stellt man das BlackBox Modul zur Verfuegung?
- Kurzer Abriss in  MP, Behandlung in MA mit Vergleich
- 1: Klare Aufgabe, wie sieht MOdulstruktur aus
- 2: Struktur fest, wie sieht komplexes Modulinnenlbene aus
- 3: Komplex Check, struktur check, wie sieht eine eigentliche aufgabe aus.
- Wie Zwischenergebniss feststellen? Studenten, die nicht alles schaffen (keine Flag) aber sich beschaftigem, wie nicht benachteiligen?
- -> Zwischen Flags? Zwischenschritte?
- -> Checkpoint system im hintergrund,
- -> Modul struktur erlaubt wohldefnierite (docker image) startpoints, die Aufgabenmodule sind darunter (aufteilung in module innerhalb der umgebung)


### 2020-06-03

- Project documentation as mdbook in git
- Signatures defined
  - CC Kannen and Leischner for antrag
- Root Server from Martina Kannen from C055
  - Write Anforderungen und request mit CC

## Dockers

docker run --name=wireshark --cap-add=NET_ADMIN --rm -e PUID=1000 -e PGID=1000 -e TZ=Europe/London -p 3000:3000 linuxserver/wireshark

-v /path/to/config:/config \
-p 3000:3000 `#optional` \

docker run --rm \
--name=taisun \
-p 3000:3000 \
-v /var/run/docker.sock:/var/run/docker.sock \
linuxserver/taisun

docker run --rm \
--name=doublecommander \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
-p 3000:3000 \
-v /:/data \
linuxserver/doublecommander

docker run --rm \
--name=projectsend \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
-e MAX_UPLOAD=5000 \
-p 3000:80 \
-v /:/data \
linuxserver/projectsend

docker run -d --rm \
--name=rdesktop \
--network docker-net-vpn --ip 172.20.20.42 \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
--shm-size="1gb" \
linuxserver/rdesktop

docker run --rm \
--name=remmina \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
-p 3000:3000 \
linuxserver/remmina