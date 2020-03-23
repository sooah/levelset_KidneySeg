function dice_btw_lsV_q = get_dice(truthV, seg)

truthV = truthV > 0;

lsV = seg;
lsV = lsV > 0;

common = (truthV & lsV);

a = sum(common(:));
b = sum(truthV(:));
c = sum(lsV(:));

dice_btw_lsV_q = 2*a/(b+c);

