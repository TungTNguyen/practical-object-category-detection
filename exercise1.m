
setup ;

load('data/signs-train.mat', trainImages, trainLabels) ;
hogCellSize = 8 ;
targetClass = 1 ;

% Compute HOG features
for i = 1:numel(trainImages)
  trainHog{i} = vl_hog(trainImages(:,:,:,i), hogCellSize) ;
end
trainHog= cat(3, trainHog{:}) ;
modelWidth = size(trainHog, 2) ;
modelHeight = size(trainHog, 1) ;

% Visualize the training images
figure(1) ; clf ;
vl_imarraysc(trainImages(:, :, :, trainLabels == targetClass)) ;

% Train a simple model
w = ...
  mean(trainHog(:,:,trainLabels == targetClass), 3) - ...
  mean(trainHog, 3) ;

% Evaluate the model on one image
im = imread('data/signs-sample-image.jpg') ;
hog = vl_hog(im2single(im), hogCellSize) ;
scores = vl_nnconv(hog, w, []) ;

[best, bestIndex] = max(scores) ;

[hy, hx] = ind2sub(size(hog), bestIndex) ;
x = (hx - 1) * hogCellSize + 1 ;
y = (hy - 1) * hogCellSize + 1 ;
box = [
  x - 0.5 ;
  y - 0.5 ;
  x + hogCellSize * modelWidth - 0.5 ;
  y + hogCellSize * modelHeight - 0.5 ;]

figure(2) ; clf ;
imagesc(im) ; axis equal ;
hold on ;
vl_plotbox(box,'linewidth', 3) ;

  










