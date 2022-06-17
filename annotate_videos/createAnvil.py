#!/usr/bin/env python
import os
import sys
import subprocess

def getLength(filename):
	result = subprocess.Popen(["ffprobe", filename],
		stdout = subprocess.PIPE, stderr = subprocess.STDOUT)
	return [x for x in result.stdout.readlines() if "Duration" in x]
	
def convertVideo(input, output):
	subprocess.call(["ffmpeg","-i", input,"-c", "h264", output])

def createAnnotationFile(filename,dur):
	file = open(filename + ".anvil", "w")
	file.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
	file.write("<annotation>\n")
	file.write("\t<head>\n")
	file.write("\t\t<specification src=\"../keraalSpec.xml\" />\n")
	videoName=filename + ".mp4"
	file.write("\t\t<video src=\"" + videoName + "\" master=\"true\" />\n")
	file.write("\t\t<info key=\"encoding\" type=\"String\">UTF-16</info>\n")
	file.write("\t</head>\n")
	file.write("\t<body>\n")
	file.write("\t\t<track name=\"Global evaluation\" type=\"primary\">\n")
	file.write("\t\t\t<el index=\"0\" start=\"0\" end=\"" + dur + "\">\n")
	file.write("\t\t\t\t<attribute name=\"evaluation\">Correct</attribute>\n")
	file.write("\t\t\t</el>\n")
	file.write("\t\t</track>\n")
	file.write("\t\t<track name=\"Global error\" type=\"primary\">\n")
	file.write("\t\t\t<el index=\"0\" start=\"0\" end=\"" + dur +"\">\n")
	file.write("\t\t\t\t<attribute name=\"type\">none</attribute>\n")
	file.write("\t\t\t</el>\n")
	file.write("\t\t</track>\n")
	file.write("\t</body>\n")
	file.write("</annotation>")
	file .close()

for f in os.listdir('.'):
	print(f)
	if f[0] == 'V' and f[len(f)-1] == 'i':
		duration=getLength(f)[0][18:23]
		print(duration)
		str=f[0:len(f)-4]
		createAnnotationFile(str,duration)
		output=str + ".mp4"
		if not os.path.isfile(output):
			convertVideo(f,output)
		

