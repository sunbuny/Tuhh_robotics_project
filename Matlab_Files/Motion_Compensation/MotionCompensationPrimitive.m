function MotionCompensationPrimitive(robObj,cameraObj,X,Y,T_C_H_des,initialConfig,varargin)
% MOTIONCOMPENSATIONPRIMITIVE moves the robot such that Tch_des is the HMT from head to coil
%
%   
%   Info:           cameraObj: object for the used tracking system
%                              (Abcatys or Kinect
%                   X: HMT from coil to head
%                   Y: HMT from tracking system to coil
%                   T_C_H_des: Desired HMT from head to coil
%   Designed by:    Nasser Attar
%   Date created:   30.06.2016
%   Last modified:  30.06.2016
%   Change Log:     

pause('on')

% Get the HMT from the Head to the Camera. This function is not available
% at the moment
% T_TS_H = GetHeadToCameraHMT(cameraObj,cameraFlag);
[T_TS_H,visibility,~] = cameraObj.getTransformMatrix();
if ~visibility
    warning('Head is not visible\n')
    return
end
 Z = Y*T_TS_H*invertHTM(T_C_H_des);
% Get the target HMT from Endeffector to Base to achieve the desired HMT
% from Head to camera (T_C_H_des)
T_B_E_des = Z*invertHTM(X);

row1 = num2str(T_B_E_des(1,:));
row2 = num2str(T_B_E_des(2,:));
row3 = num2str(T_B_E_des(3,:));

% Move robot to the desired pose. This moving should be done with a function 
% which also features collision detection
%currentHMT_B_E = UR5getPositionHomRowWise(robObj);
command = ['MoveMinChangeRowWiseStatus ' row1,' ',row2,' ',row3,' ','noToggleHand noToggleElbow noToggleArm'];
% Give the robot some time for rest
pause(0.002);
output = UR5sendCommand(robObj,'BRAKE');
output = UR5sendCommand(robObj,command);
if ~strfind(output,'true')
    warning('\nMotion Compensation was not successful\n')
end

% Wait until the joints don't change anymore (robot arrived)
% temp2 = 0;
% while 1
%     temp1 = UR5getPositionJoints(robObj);
%     if isequal(temp1,temp2)
%         break;
%     end
%     temp2 = temp1;
%     pause(0.5);
% end

% End of function
end