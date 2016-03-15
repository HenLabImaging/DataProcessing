function c=cos_sim(x,y)
    c=(x*y')/(vectoral_sum(x)*vectoral_sum(y));
end

function y= vectoral_sum(x)
    y=sqrt(sum(x(:).^2));
end
