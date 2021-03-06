clear all
close all
clc

%% Load Matlab data file and extract variables of interest
cdir = fileparts(mfilename('fullpath')); 
fileName = fullfile(cdir,'../project_1/letter.mat');
mat_data = load(fileName);

%% Retrieving and extracting data
X = mat_data.X;
A = mat_data.A;
DA = mat_data.DA;
classNames = mat_data.classnames;
classlabel = mat_data.classlabel;
attributeNames = mat_data.attributeNames;
cont = mat_data.cont;

%% Data Analysis

% for each atrtibute specify MEAN VARIANCE MEDIAN RANGE STD
mean = mean(X);
v= var(X);
median = median(X);
range = range (X);
std = std(X);

%matrix 16x5 (16=#attributes  -  5= MEAN VARIANCE MEDIAN RANGE STD)  
DA = [ mean' v' median' range' std'] ;

% Distributions (histograms)
M1=8; 
M2=16; % # attributes
N=20000;

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean);

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y, 'econ');

% Compute the projection onto the principal components
Z = U*S;

% Compute variance explained
rho = diag(S).^2./sum(diag(S).^2);

% Compute PCA
x=1:1:16;
[COEFF, SCORE, LATENT] = princomp(X);
CV=cumsum(var(SCORE)) / sum(var(SCORE));

% Compute Correlation coefficients
R = corrcoef(X)

%% Visualization


% Histograms

mfig('Histogram for attributes 1'); clf; hold all;
for m = 1:M1
    u = floor(sqrt(M1)); v = ceil(M1/u);
    subplot(u,v,m);
    hist(X(:,m));
	xlabel(attributeNames{m});  
    axis square;
end
linkax('y'); % Makes the y-axes equal for improved readability

mfig('Histogram for attributes 2'); clf; hold all;
for m = 9:M2
    n=m-8;
    subplot(2,4,n);
	hist(X(:,m));
    xlabel(attributeNames{m});
	axis square;
end
linkax('y'); % Makes the y-axes equal for improved readability

%% BOX PLOT of each attribute
mfig('Letters: Boxplot attributes'); clf;
boxplot(X, attributeNames);

%{ 

% IF THERE IS NEED FOR MORE

%better visualization
mfig('Boxplot1'); clf;
boxplot(X(:,1:8), attributeNames(1:8));
mfig('Boxplot2'); clf;
boxplot(X(:,9:16), attributeNames(9:16));

%ordered vector with A=1 B=2 C=3 ecc...
t=cont(1);
group(1:cont(1))=1;
for i=2:26
    group((t+1):(t+cont(i)))=i;
    t=t+cont(i);
end

%repeat this code for each attribute

%% Boxplot of each attribute for each class (%we must divede it in two part for a better visualization )
mfig('Boxplot1'); clf; hold all;
boxplot(A(:,1)', group );

%BOX PLOT standardized
%mfig('Letters: Boxplot (standardized) attributes');
%boxplot(zscore(X), attributeNames, 'LabelOrientation', 'inline');

%}

%% Boxplot of each attribute for each class (divided in 4 fig.)
t=1;
mfig('Boxplot per class (1)'); clf;
for c = 1:3
    subplot(1,3,c);
    boxplot(A(t:(t-1)+cont(c),:), attributeNames, 'labelorientation', 'inline');   
    t=t+cont(c);
    title(classNames{c});    
end
linkax;

% mfig('Boxplot per class (2)'); clf;
% for c = 8:14
%     subplot(1,7,c-7);
%     boxplot(A(t:(t-1)+cont(c),:), attributeNames, 'labelorientation', 'inline');   
%     t=t+cont(c);
%     title(classNames{c});    
% end
% linkax;
% 
% mfig('Boxplot per class (3)'); clf;
% for c = 15:21
%     subplot(1,7,c-14);
%     boxplot(A(t:(t-1)+cont(c),:), attributeNames, 'labelorientation', 'inline');   
%     t=t+cont(c);
%     title(classNames{c});    
% end
% linkax;
% 
% mfig('Boxplot per class (4)'); clf;
% for c = 22:26
%     subplot(1,5,c-21);
%     boxplot(A(t:(t-1)+cont(c),:), attributeNames, 'labelorientation', 'inline');   
%     t=t+cont(c);
%     title(classNames{c});    
% end
% linkax;


%% Plot variance explained
mfig('Letters: Var. explained'); clf;
plot(rho, 'o-');
title('Variance explained by principal components');
xlabel('Principal component');
ylabel('Variance explained value');

x=1:1:16
[COEFF SCORE LATENT] = princomp(X);
CV=cumsum(var(SCORE)) / sum(var(SCORE));
mfig('Letters: Cumulative Variance'); clf;
plot(x,CV, 'o-');
grid on
title('Cumulative variance explained by principal components');
xlabel('Principal component');
ylabel('Total Variance');


% Plot PCA of data

% first 2 principal components - all data
mfig('Letters: PCA (2D)'); clf; hold all; 
C = length(classNames);
for c = 1:C
    plot(Z(strcmp(classlabel',classNames(c))==1,1), Z(strcmp(classlabel',classNames(c))==1,2), '.');
end
legend(classNames);
xlabel('PC 1');
ylabel('PC 2');
title('PCA of letters data (2D)');

% first 3 principal components - all data
mfig('Letters: PCA (3D)'); clf; hold all; 
C = length(classNames);
for c = 1:C
    plot3(Z(strcmp(classlabel',classNames(c))==1,1), Z(strcmp(classlabel',classNames(c))==1,2),Z(strcmp(classlabel',classNames(c))==1,3),'.');
end
legend(classNames);
grid on
xlabel('PC 1');
ylabel('PC 2');
zlabel('PC 3');
title('PCA of letters data (3D)');

% first 3 principal components - fist 3 letters
mfig('Letters: PCA 3D - letters A,B,C'); clf; hold all; 
for c = 1:3
    plot3(Z(strcmp(classlabel',classNames(c))==1,1), Z(strcmp(classlabel',classNames(c))==1,2),Z(strcmp(classlabel',classNames(c))==1,3),'.');
end
legend(classNames);
grid on
xlabel('PC 1');
ylabel('PC 2');
zlabel('PC 3');
title('PCA of letters data (3D) - letters A,B,C');


%% TODO: WHAT ABOUT THAT? 
   
%{ 
Scatter Plots
M=16;
C=26
mfig('Matrix of scatter plots'); clf;
for m1 = 1:M
    for m2 = 1:M
        subplot(M,M,(m1-1)*M+m2, 'align'); hold all;
        for c = 0:C
            plot(X(group==c,m2), X(group==c,m1), '.');
        end
        axis tight;
        if m1<M, set(gca, 'XTick', []); else xlabel(attributeNames{m2}); end;
        if m2>1, set(gca, 'YTick', []); else ylabel(attributeNames{m1}); end;
    end
end
legend(classNames);
%}

