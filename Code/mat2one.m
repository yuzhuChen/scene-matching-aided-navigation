%����������һ��[0,1]����
function matOut=mat2one(matIn)
[matOut,PM]=mapminmax(matIn(:)',0,1);
matOut=reshape(matOut,[],size(matIn,2));