#This file is used to change the configuration file of Eclipse so that it uses Java 8
#install of Java 7
data = []
with open('/usr/local/eclipse/eclipse.ini') as file:
    for line in file:
        if "1.7" in line:
            line = line.replace("1.7", "1.8")

        data.append(line)

with open("/usr/local/eclipse/eclipse.ini", 'w') as file:
    for line in data:
        file.write(line)
    file.close()
