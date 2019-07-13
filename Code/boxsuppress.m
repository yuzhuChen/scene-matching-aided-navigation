%Non Maximum Suppression
im = imread(testImages{3}) ;
im = im2single(im) ;

% Compute detections
[detections, scores] = detect(im, w, hogCellSize, scales) ;%w,hogCellSize,scales

% Non-maxima suppression
keep = boxsuppress(detections, scores, 0.25) ;

detections = detections(:, keep) ;
scores = scores(keep) ;

% Further keep only top detections
detections = detections(:, 1:10) ;
scores = scores(1:10) ;

function keep = boxsuppress(boxes, scores, threshold)
% BOXSUPPRESS Box non-maxima suprression（非最大值抑制）
%   KEEP = BOXSUPPRESS(BOXES, SCORES, THRESHOLD)

% remove any empty box (xmax < xmin or ymax < ymin)
scores(any([-1 0 1 0 ; 0 -1 0 1] * boxes < 0)) = -inf ;

keep = false(1, size(boxes,2)) ;
while true
  [score, best] = max(scores) ;
  if score == -inf, break ; end
  keep(best) = true ;
  remove = boxinclusion(boxes(:,best), boxes, 'pascalFormat', true) >= threshold ;
  scores(remove) = -inf ;
  scores(best) = -inf ; % `best` is not in `remove` if threshold > 1
end

function dist = calcBoxInclusion(A, B, varargin)
%%boxinclusion
?% GETBOXOVERLAP
%   A and B have a box for each column, in the format [xmin ymin xmax
%   ymax]. The resulting matrix dist has A's boxes along the rows
%   and B's boxes along the columns and contains the percentage of
%   the area of each box B contained in the box A.

opts.pascalFormat = false ;
opts = vl_argparse(opts, varargin) ;

m = size(A,2) ;
n = size(B,2) ;
O = [] ;

if m==0 || n==0, dist = zeros(m,n) ; return ; end

om = ones(1,m) ;
on = ones(1,n) ;

if opts.pascalFormat
  A(3:4,:) = A(3:4,:) + 1 ;
  B(3:4,:) = B(3:4,:) + 1 ;
end

% find length Ox of the overlap range [x1, x2] along x
% x1 cannot be smaller than A.xmin B.xmin
% x2 cannot be larger  than A.xmax B.xmax
% Ox is x2 - x1 or 0

x1 = max(A(1*on,:)', B(1*om,:)) ;
x2 = min(A(3*on,:)', B(3*om,:)) ;
Ox = max(x2 - x1, 0) ;

y1 = max(A(2*on,:)', B(2*om,:)) ;
y2 = min(A(4*on,:)', B(4*om,:)) ;
Oy = max(y2 - y1, 0) ;

% are of the intersection
areaInt = Ox .* Oy ;

% area of the union is sum of areas - inersection
areaA = prod(A(3:4,:) - A(1:2,:)) ;
areaB = prod(B(3:4,:) - B(1:2,:)) ;

% final distance matrix
dist = areaInt ./ (areaB(om,:) + eps) ;
% --------------------- 
% 作者：鹊踏枝-码农 
% 来源：CSDN 
% 原文：https://blog.csdn.net/u011501388/article/details/79586896 
% 版权声明：本文为博主原创文章，转载请附上博文链接！