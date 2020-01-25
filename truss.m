    clear
    clc
    close all
    
    j_num = input('enter number of joints in your truss ');
    m_num = 2*j_num-3;      % a relationship that relates number of members to number of joints in DETERMINANT truss
    j_x = zeros(j_num,1);   % initialization to x coordinates of joints matrix
    j_y = zeros(j_num,1);   % initialization to y coordinates of joints matrix
    
                            % in this following part coordinates of joints are taken from user
    for g = 1:j_num
     fprintf('enter x coordinate of joint number %d ',g)
     jx = input(' = ');
     fprintf('enter y coordinate of joint number %d ',g)
     jy = input(' = ');
     fprintf('\n')
     j_x(g,1) = jx;
     j_y(g,1) = jy;
    end
    
    clc
    
                            % Like a report that will be displayed to the user cointaining the x and y of each joint and the number of the joint
    for cz = 1:j_num
     fprintf('joint %d : (%6.1f,%6.1f)',cz,j_x(cz),j_y(cz))
     fprintf('\n')
     fprintf('\n')
    end
    
    fprintf('\n')
    q = 0;
    f = ones(2*j_num,1);    % initialization to matirx of ext. forces
    f_x = zeros(j_num,1);   % initialization to matirx of x-ext. forces
    f_y = zeros(j_num,1);   % initialization to matirx of y-ext. forces

                            % in the following part external forces are taken from user
                            % For "F_x"&"F_y" they are used for upcoming report and for "f" it will be used to calculate int. forces
    for e = 1:j_num
     fprintf('enter x component of external force at joint %d ',e)
     fx = input(' = ');
     fprintf('enter y component of external force at joint %d ',e)
     fy = input(' = ');
     fprintf('\n')
     f_x(e,1) = fx;
     f_y(e,1) = fy;
     q = q+1;              % This statement is a kind of making two parallel loops goes with each other each with its step 
     f(q,1) = fx;
     q = q+1;
     f(q,1) = fy;
    end
    
    clc

                          % In the following part another report will
                          % appear but this time containing (joint number,joint as x and y, and ext. forces at each joint)
    for tn = 1:j_num
     fprintf('joint %d : (%6.1f,%6.1f) Fx = %7.2f Fy = %7.2f ',tn,j_x(tn),j_y(tn),f_x(tn,1),f_y(tn))
     fprintf('\n')
    end
    
    fprintf('\n')
    b = 0;
    c = zeros(2*j_num,m_num);                   % c is the matrix of (x_end - x_begin)/length and the same for y which is an important matrix in solving for int. forces
    
    for a = 1:m_num
     set(0,'DefaultFigureWindowStyle','docked') % a coomand that makes figure docked in matlab main window
     fprintf('member %d in your truss is ',a)
     m = input('from joint ');
     mm = input('                          to   joint ');
     fprintf('\n')
     w = (j_x(mm,1) - j_x(m,1))/sqrt((j_x(mm,1)-j_x(m,1))^2+(j_y(mm,1)-j_y(m,1))^2);
     c(2*m-1,a) = w;                            % for matrix index that is like that "2m-1" it is for the x component in "c" matrix
     c(2*mm-1,a) = -1*c(2*m-1,a);               % this line is because on each member there will be two forces one is merley in +ve x and in -ve x representing wether tension or compression
     u = (j_y(mm,1) - j_y(m,1))/sqrt((j_x(mm,1)-j_x(m,1))^2+(j_y(mm,1)-j_y(m,1))^2);
     c(2*m,a) = u;                              % for matrix index that is like that "2m" it is for the x component in "c" matrix
     c(2*mm,a) = -1*c(2*m,a);                   % this line is because on each member there will be two forces one is merley in +ve y direction and in -ve y representing wether tension or compression
     line([j_x(m) j_x(mm)],[j_y(m) j_y(mm)],'linewidth',3);                                   % this function will draw truss member by member
     text(((j_x(m)+j_x(mm))/2),((j_y(m)+j_y(mm))/2),int2str(a),'color','r','Fontsize',15)     % and this will write number of each member on it in the figure 
    end
    
    clc
    
                                                % this is the last report eactly that will appear and below it int. forces and beside it the drawn truss
    for tn = 1:j_num
     fprintf('joint %d : (%6.1f,%6.1f) Fx = %7.2f Fy = %7.2f ',tn,j_x(tn),j_y(tn),f_x(tn,1),f_y(tn))
     fprintf('\n')
    end
    
    f_in = linsolve(c,-1*f);                    % the function that will solve for int. forces
    tol = 1.e-6;                                % this to solve the problem of "-ve zero" that appear in the solved system
    fprintf('\n')    
    
                                                % and this is the final reprot that will display the internal force in each member
    for q = 1:m_num
     f_in(f_in<0 & f_in>-tol) = 0;
     fprintf('internal force at member %d = %0.2f\n',q,f_in(q))
     fprintf('\n')
    end