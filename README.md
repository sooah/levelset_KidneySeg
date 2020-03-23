# levelset_KidneySeg

#### 함수 정리
- compile_sfm_chanvese : sfm code
- ct_cut : area size에 따라서 ct cut size를 다르게 잡아줌
- divide_spect : image left, right divide
- get_areainfo_spect : area size 구함
- get_centerinfor_spect	: preprocessing 된 spect image에서 weighted center 잡음
- get_dice : dice coefficient
- get_ellipse	: ellipse 잡기
- get_error	: 좌우 따로 truthV와 비교할때 썼었음...
- get_size_left	: ellipse 잡을때 좌우 각도가 달라서 따로 잡아줌
- get_size_right : ellipse 잡을때 좌우 각도가 달라서 따로 잡아줌
- iter_num : size에 따라 iteration num 
- lvlset_sfm_coronal : segmentation 
- main : 77명 전체 자동으로 돌릴때 사용
- manualSelect : sfm code
- open_image : dicom image open
- prc : debug 시 사용
- pre_spect_area : spect image preprocessing
- scaling_image : ct 받아와서 처음 열때 한번 processing, 변환 기준 400이상, 210이하 0으로 제거
- sfm_chanvese : sfm code
그 외 함수 모두 sfm code
