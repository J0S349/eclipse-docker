# This file is used to change the configuration file of Eclipse so that it uses Java 8
# instead of Java 7
data = []
# Copy the lines into a list
with open('/usr/local/eclipse/eclipse.ini') as file:
    for line in file:
        # This will check to see whether a line read in contains the minimal java version required
        if "1.7" in line:
            # We then replace the 1.7 with 1.8
            line = line.replace("1.7", "1.8")
        data.append(line)

# We then open up the file with write access which clears the file
with open("/usr/local/eclipse/eclipse.ini", 'w') as file:
    for line in data:
        # We then write to the file with the updated information
        file.write(line)
    # We then close access to the file
    file.close()
