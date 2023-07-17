clear, clc;
ipcam_url = 'http://192.168.10.22/240x240.mjpeg';
ipcam_handle = ipcam(ipcam_url);
while(1)

    img = snapshot(ipcam_handle);
    imshow(img);
    [msg,~,loc] = readBarcode(img);
    disp(msg);

end