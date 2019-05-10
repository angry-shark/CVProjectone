
function H = Compute_H(Points,Points_prime)
[n_Points T] = Normal(Points);
[n_Points_prime T_prime] = Normal(Points_prime);
H_normal = Compute_H_normal(n_Points,n_Points_prime);
H = T_prime\(H_normal*T);



function H_normal = Compute_H_normal(Points,Points_prime)
n=size(Points,1);
a = zeros(2*n,9);
for i=1:n
    a(2*i-1,1)= -Points(i,1);
    a(2*i-1,2)= -Points(i,2);
    a(2*i-1,3)= -1;
    a(2*i-1,4)= 0;
    a(2*i-1,5)= 0;
    a(2*i-1,6)= 0;
    a(2*i-1,7)= Points(i,1)*Points_prime(i,1);
    a(2*i-1,8)= Points(i,2)*Points_prime(i,1);
    a(2*i-1,9)= Points_prime(i,1);
    
    a(2*i,1)= 0;
    a(2*i,2)= 0;
    a(2*i,3)= 0;
    a(2*i,4)= -Points(i,1);
    a(2*i,5)= -Points(i,2);
    a(2*i,6)= -1;  
    a(2*i,7)= Points(i,1)*Points_prime(i,2);
    a(2*i,8)= Points(i,2)*Points_prime(i,2);
    a(2*i,9)= Points_prime(i,2);
end
[u, s, v] = svd(a);
h = v(:, end);
H_normal = reshape(h,[3 3]);

function [normal_Points T]= Normal(Points)
n=size(Points,1);
P_mean = mean(Points);
P_move = zeros(n,2);
for i=1:n
    P_move(i,:) = Points(i,:)-P_mean;
end
P_dis = sqrt(sum(P_move.^2,2));
avg_dis = mean(P_dis);
T = zeros(3,3);
T(1,1) = sqrt(2)/avg_dis;
T(2,2) = sqrt(2)/avg_dis;
T(3,3) = 1;
T(1,3) = -(sqrt(2)/avg_dis)*P_mean(1,1);
T(2,3) = -(sqrt(2)/avg_dis)*P_mean(1,2);
normal_Points = P_move./avg_dis;


