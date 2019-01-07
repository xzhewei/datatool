function rescore = post_roadline(type,score,y,roadline,nD,nA,nB)
% Rescoring the bbox based on the roadline
distance = roadline - y;
alpha = 1 - exp(-abs(distance./nD));
beta = 1 - score;
switch(type)
    case 'linear'
        rescore = linear(score,alpha,beta,nA,nB);
    case 'multi'
        rescore = multiply(score,alpha,beta,nA);
    otherwise
        fprintf('The vaild type only for linear or multi, there are not type of %s.\n',type);        
end
end

function rescore = linear(score,alpha,beta,nA,nB)
% linear cost function
rescore = score - nB.*beta - nA.*alpha;
end

function rescore = multiply(score,alpha,beta,nA)
% multiply cost function
rescore = score - nA.*beta.*nA.*alpha;
end