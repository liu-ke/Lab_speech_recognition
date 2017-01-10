function [adapted_mu,adapted_cov,adapted_weights]=speakermodel(ubmdata,features)
%
ubm_mu=ubmdata.means;
ubm_sigma=ubmdata.var;
ubm_weights=ubmdata.weights;                                          %wieghts, sum up to 1
new_mu=zeros(size(features,1),ubmdata.K);
new_cov=zeros(ubmdata.D,ubmdata.D);
new_weights=zeros(1,ubmdata.K);
adapted_mu=new_mu; 
adapted_cov=new_cov;
adapted_weights=new_weights;
gamma=1;
for k=1:ubmdata.K
    sum_p_ubm=0;
    p_ubm=0;
    temp_for_mu=zeros(ubmdata.D,1);
    temp_for_cov=zeros(size(new_cov));
    obj=gmdistribution(ubm_mu(k,:),diag(ubm_sigma(k,:),0),ubm_weights(k));                    %generate a GMM model with mu, sigma, and p
    for t=1:size(features,2)
        for i=1:ubmdata.K                                                   %compute p_ubm(bt)
            obj_ubm=gmdistribution(ubm_mu(i,:),diag(ubm_sigma(i,:),0),ubm_weights(i));
            p_ubm=p_ubm+ubm_weights(i)*pdf(obj_ubm,features(:,t)');
        end
        y=pdf(obj,features(:,t)');
        p_on_bt=ubm_weights(k)*y/p_ubm;                                     %compute p(k|bt)
        temp_for_mu=temp_for_mu+p_on_bt.*features(:,t);                     %vector 15*1
        temp_for_cov=temp_for_cov+p_on_bt.*features(:,t)*features(:,t)';    %matrix 15*15
        sum_p_ubm=sum_p_ubm+p_on_bt;
    end
    alpha=sum_p_ubm/(gamma+sum_p_ubm);
    new_mu(:,k)=temp_for_mu/sum_p_ubm;
    new_cov=temp_for_cov/sum_p_ubm-new_mu*new_mu';                          %new_cov(k) matrix 15*15
    new_weights(:,k)=sum_p_ubm/size(features,2);
    adapted_mu(:,k)=alpha.*new_mu(:,k)+(1-alpha).*ubm_mu(k,:)';
    adapted_cov=alpha.*new_cov+(1-alpha).*diag(ubm_sigma(k,:),0);                   %adapted_cov matrix 15*15
    adapted_weights(:,k)=alpha.*new_weights(:,k)+(1-alpha).*ubm_weights(k);
end