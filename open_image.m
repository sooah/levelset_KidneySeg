function V = open_image(file,msize)

out = dir(file);
fid = fopen(file,'r');
dataStack = fread(fid,out.bytes/2,'short');
fclose(fid);
numData = out.bytes/2/(msize*msize);
V = reshape(dataStack,[msize,msize,numData]);


