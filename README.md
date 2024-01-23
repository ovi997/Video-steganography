# Video-steganography
1.	Se adaugă calea proiectului în Current Folder (Fig. 2).
2.	Se adaugă cele 4 foldere în calea de lucru (Fig. 3). 

Ascunderea textului în video:
1.	Se deschide script-ul textEncrypt.m și se asignează variabilei watermark textul dorit.
2.	Se rulează prima secțiune a codului.
3.	La finalul execuției se va afișa în linia de comanda “FINISHED = 0”, reprezentând execuția cu succes a codului.
4.	În folderul key se va scrie automat un fișier .txt conținând, în ordine, frame-ul în care a fost introdus textul și indicii pixelilor modificați din fiecare dintre cele 3 plane - R, G, B.
5.	În folderul results se vor scrie video encryptedVideo.avi – fiind rezultatul criptării textului și fișierul decryptedText.txt – conține textul extras din video menționat anterior.
Codul din script-ul executat este dependent de următoarele funcții:
•	generateUniqueIndexes.m – pentru generarea cheii
•	encryptFrame.m – pentru criptare
•	decryptFrame.m – pentru decriptare
Ascunderea imaginii în video:
1.	Se deschide script-ul imageEncrypt.m și se setează variabilele moviePATH și imagePATH, cu calea aferentă video-ului și imaginii utilizate.
2.	Se rulează întreg script-ul.
3.	La finalul execuției se va afișa în linia de comanda “FINISHED = 0”, reprezentând execuția cu succes a codului.
4.	În folderul key se va scrie automat un fișier .txt conținând, indexul fiecărui frame în care a fost înlocuit un plan de biți.
5.	În folderul results se vor scrie video encryptedVideo.avi – fiind rezultatul criptării imaginii.
Codul din script-ul executat este dependent de următoarele funcții:
•	generateUniqueIndexes.m – pentru generarea cheii
•	scaleImage.m – pentru redimensionarea imaginii conform rezoluției video
•	encryptFrameImage.m – pentru criptare
•	restoreBitPlan.m – pentru decriptare
De asemenea, mai sunt disponibile funcțiile:
•	rgb2yuv – conversie din RGB în YUV
•	yuv2rgb – conversie din RGB în YUV
•	restoreBitPlanYUV –  pentru decriptare
Acestea pot fi utilizate pentru a înlocui imaginea în planul de biți al luminanței unui frame, dar din cauza pierderilor apărute în urma aproximărilor la conversia RGB-YUV și invers, rezultatul nu este la fel de performant.
