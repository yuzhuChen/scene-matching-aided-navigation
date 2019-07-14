%把任意矩阵归一化[0,1]区间
function matOut=mat2one(matIn)
[matOut,PM]=mapminmax(matIn(:)',0,1);
matOut=reshape(matOut,[],size(matIn,2));