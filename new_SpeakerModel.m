function [adapted_mu,adapted_cov,adapted_weights]=new_SpeakerModel(ubmdata,features)
%Adapt a GMM for each speaker
%ubmdata: a struct with 5 fields:var,K,weights,D,means
%features: 170*1 cell, with each element MFCC features (dim 15*num_frames)
%adapted_mu: 170*1 cell, with each element GMM means for one speaker (dim 15*49)
%adapted_cov: 170*1 cell, with each element GMM covariances for one speaker (dim 15*49)
%adapted_weights: 170*1 cell, with each element GMM weights for one speaker (dim 1*49)
attr_dimension=size(features{1,1},1);                           %should be 15
ubm_mu=ubmdata.means;                                           %means in Universal Background Model(49*15)
ubm_sigma(1,:,:)=ubmdata.var';                                  %covariances in Universal Background Model(1*15*49)
ubm_weights=ubmdata.weights;                                    %weights in Universal Background Model(1*49)

adapted_mu=cell(length(features),1);                            %a 170*1 cell
adapted_cov=cell(length(features),1);                           %a 170*1 cell
adapted_weights=cell(length(features),1);                       %a 170*1 cell

new_mu=zeros(attr_dimension,ubmdata.K);                         %a 15*49 matrix
new_cov=zeros(ubmdata.D,ubmdata.K);                             %a 15*49 matrix
new_weights=zeros(1,ubmdata.K);                                 %a 1*49 matrix

obj=gmdistribution(ubm_mu,ubm_sigma,ubm_weights);            %generate a GMM model with mu, sigma, and p
gamma=1;                                                    %relevence factor
alpha=zeros(ubmdata.K,1);
for n=1:length(features)
    num_frames=size(features{n,1},2);
    p_ubm=pdf(obj,features{n,1}');                                               %compute p_ubm(b)
    pk_on_b=zeros(size(features{n,1},2),ubmdata.K);                              %dimension: num_frames*49
    for k=1:ubmdata.K
        pk_on_b(:,k)=ubm_weights(k)*mvnpdf(features{n,1}',ubm_mu(k,:),ubm_sigma(1,:,k))./p_ubm; %posteriori (num_frames*1)
        new_mu(:,k)=features{n,1}*pk_on_b(:,k)./sum(pk_on_b(:,k));                              %attr_dim*1
        temp=repmat(pk_on_b(:,k)',attr_dimension,1).*features{n,1};
        new_cov(:,k)=diag(temp*features{n,1}'./sum(pk_on_b(:,k))-new_mu(:,k)*new_mu(:,k)');
        new_weights(k)=sum(pk_on_b(:,k))/num_frames;
        alpha(k)=sum(pk_on_b(:,k))/(gamma+sum(pk_on_b(:,k)));
    end
    adapted_mu{n,1}=bsxfun(@times,new_mu,alpha')+bsxfun(@times,ubm_mu',(ones(size(alpha))-alpha)');%15*49
    adapted_cov{n,1}=bsxfun(@times,new_cov,alpha')+bsxfun(@times,ubmdata.var',(ones(size(alpha))-alpha)');%15*49
    adapted_weights{n,1}=bsxfun(@times,new_weights,alpha')+bsxfun(@times,ubm_weights,(ones(size(alpha))-alpha)');%1*49
    
end