function [right_error_seg, left_error_seg] = get_error(truthV, spectV, seg)

right_truthV = (truthV == 5120);
left_truthV = (truthV == 7168);

right_truthV_spect = right_truthV.*spectV;
left_truthV_spect = left_truthV.*spectV;

[right_seg, left_seg] = divide_spect(seg);

right_seg_spect = right_seg.*spectV;
left_seg_spect = left_seg.*spectV;

num_right_truthV_spect = sum(sum(sum(right_truthV_spect)));
num_left_truthV_spect = sum(sum(sum(left_truthV_spect)));

num_right_seg_spect = sum(sum(sum(right_seg_spect)));
num_left_seg_spect = sum(sum(sum(left_seg_spect)));

right_error_seg = abs(num_right_truthV_spect - num_right_seg_spect) /(num_right_truthV_spect);
left_error_seg = abs(num_left_truthV_spect - num_left_seg_spect)/(num_left_truthV_spect);