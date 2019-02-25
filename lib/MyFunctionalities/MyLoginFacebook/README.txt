Para crear el HASH si no anda como esta en la documentación de Facebook Developer hacer lo siguiente:

Dentro del JRE instalado hacer:
C:\Program Files\Java\jre1.8.0_181\bin>keytool -list -v -keystore C:\Users\adrid_000\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

Generará lo siguiente:

Nombre de Alias: androiddebugkey
Fecha de Creación: 13/07/2018
Tipo de Entrada: PrivateKeyEntry
Longitud de la Cadena de Certificado: 1
Certificado[1]:
Propietario: C=US, O=Android, CN=Android Debug
Emisor: C=US, O=Android, CN=Android Debug
Número de serie: 1
Válido desde: Fri Jul 13 01:49:49 ART 2018 hasta: Sun Jul 05 01:49:49 ART 2048
Huellas digitales del certificado:
         MD5: 2C:BD:EF:77:7F:2B:29:07:81:E7:03:03:E1:97:6A:0B
         SHA1: 22:3A:94:6E:DD:05:79:FB:47:C7:17:31:AC:E6:EA:62:28:78:14:21
         SHA256: 3D:69:6A:E8:6A:51:6A:EB:EA:20:BB:F2:99:B3:D2:41:2E:D1:C4:0D:2D:4B:46:62:B0:F1:7D:D4:E3:9E:68:45
Nombre del algoritmo de firma: SHA1withRSA
Algoritmo de clave pública de asunto: Clave RSA de 1024 bits
Versión: 1

--> tomar el SHA1: 22:3A:94:6E:DD:05:79:FB:47:C7:17:31:AC:E6:EA:62:28:78:14:21
y pasarlo a base64 en la pagina http://tomeko.net/online_tools/hex_to_base64.php

y pegar lo que te genera en la sección de Settings > Basic > Key Hashes.

LISTO!! ;)