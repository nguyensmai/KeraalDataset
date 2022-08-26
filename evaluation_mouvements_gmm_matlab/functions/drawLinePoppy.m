function drawLinePoppy( posVec, colVec )
%DRAWLINEPOPPY Summary of this function goes here
%   Detailed explanation goes here
    
    
    line([posVec(1) posVec(4)],[posVec(2) posVec(5)],[posVec(3) posVec(6)],'Color',colVec(1:3),'LineWidth',2);
    hold on;line([posVec(4) posVec(7)],[posVec(5) posVec(8)],[posVec(6) posVec(9)],'Color',colVec(4:6),'LineWidth',2);
    hold on;line([posVec(7) posVec(10)],[posVec(8) posVec(11)],[posVec(9) posVec(12)],'Color',colVec(7:9),'LineWidth',2);
    
    hold on;line([posVec(7) posVec(13)],[posVec(8) posVec(14)],[posVec(9) posVec(15)],'Color',colVec(10:12),'LineWidth',2);
    hold on;line([posVec(13) posVec(16)],[posVec(14) posVec(17)],[posVec(15) posVec(18)],'Color',colVec(13:15),'LineWidth',2);
    hold on;line([posVec(16) posVec(19)],[posVec(17) posVec(20)],[posVec(18) posVec(21)],'Color',colVec(16:18),'LineWidth',2);
   
    hold on;line([posVec(7) posVec(22)],[posVec(8) posVec(23)],[posVec(9) posVec(24)],'Color',colVec(19:21),'LineWidth',2);
    hold on;line([posVec(22) posVec(25)],[posVec(23) posVec(26)],[posVec(24) posVec(27)],'Color',colVec(22:24),'LineWidth',2);
    hold on;line([posVec(25) posVec(28)],[posVec(26) posVec(29)],[posVec(27) posVec(30)],'Color',colVec(25:27),'LineWidth',2);
    
    ylim([-1 1]);
    xlim([-1 1]);
    view([0 90]);
    
end

