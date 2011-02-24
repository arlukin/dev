hcitool scan
sdptool browse 00:1C:A4:C0:59:5A
rfcomm bind /dev/rfcomm0 00:1C:A4:C0:59:5A 9
mknod /dev/rfcomm0 c 216 0 && mknod /dev/rfcomm1 c 216 1
sudo ussp-push /dev/rfcomm0 message.txt message.txt 
rfcomm release /dev/rfcomm0 


hcitool scan
sdptool browse 00:1C:A4:C0:59:5A
ussp-push 00:1C:A4:C0:59:5A@3 message.txt message.txt 




cat res | awk \
'BEGIN { FS = "[^A-Za-z]+" }

{ for(i = 1 ; i <= NF ; i++)  word[$i] = "" }

END { delete word[""]
  for ( i in word )  {cnt++; print i;}
  print cnt
}

'

