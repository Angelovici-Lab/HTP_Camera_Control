classdef ImageProcessor < handle
    %% private fields
    properties(Access=private)
        
		seperator = [];
		
		leftSideImage = [];
		topImage = [];
		rightSideImage = [];
		
		image_sframe1 = [];
		image_sframe2 = [];
		image_sframe3 = [];
		image_sframe4 = [];
		image_stframe5 = [];
		image_stframe6 = [];
		image_stframe7 = [];
		image_stframe8 = [];
		image_stframe9 = [];
		image_stframe10 = [];
		image_stframe11 = [];
		image_stframe12 = [];
		image_sframe13 = [];
		image_sframe14 = [];
		image_sframe15 = [];
		image_sframe16 = [];
        
        msg1 = [];
        msg2 = [];
        msg3 = [];
        msg4 = [];
        msg5 = [];
        msg6 = [];
        msg7 = [];
        msg8 = [];

        seq1 = 0;
        seq2 = 0;
        seq3 = 0;
        seq4 = 0;
        seq5 = 0;
        seq6 = 0;
        seq7 = 0;
        seq8 = 0;
		
        experimentName = '';
        repNumber = '';
        roundNumber = '';
        trayNumber = '';
        csNumber = '';
        
        savePath = '';
        
    end
    %% constants
    properties(Constant, Hidden=true)
    end
    %% private methods
    methods(Access=private)
        %% Clear message and sequence fields
        % clear scan code related fields
        function obj = clearMsgSeqFields(obj)
            obj.msg1 = [];
            obj.msg2 = [];
            obj.msg3 = [];
            obj.msg4 = [];
            obj.msg5 = [];
            obj.msg6 = [];
            obj.msg7 = [];
            obj.msg8 = [];

            obj.seq1 = 0;
            obj.seq2 = 0;
            obj.seq3 = 0;
            obj.seq4 = 0;
            obj.seq5 = 0;
            obj.seq6 = 0;
            obj.seq7 = 0;
            obj.seq8 = 0;
        end
        %% Decode 1D and 2D code
        % decode aztec code
        function message = decode_aztec(obj, img)
            % include java read 2D code library
            javaaddpath('.\core-3.3.0.jar');
            javaaddpath('.\javase-3.3.0.jar');
            % import required package
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*; % BinaryBitmap;
            import com.google.zxing.common.*;
            %import com.google.zxing.Result;
            import com.google.zxing.aztec.*; % AztecReader;
            % start decode
            jimg = im2java2d(img);
            source = BufferedImageLuminanceSource(jimg);
            bitmap = BinaryBitmap(HybridBinarizer(source));
            aztec_reader = AztecReader;
            try 
                result = aztec_reader.decode(bitmap);
                message = char(result.getText());
            catch e
                message = [];        
            end
            clear source;
            clear jimg;
            clear bitmap;
        end
        % decode code39
        function message = decode_code39(obj, img)
            % include java read 2D code library
            javaaddpath('.\core-3.3.0.jar');
            javaaddpath('.\javase-3.3.0.jar');
            % import required package
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*; % BinaryBitmap;
            import com.google.zxing.common.*;
            %import com.google.zxing.Result;
            import com.google.zxing.oned.*; % Code39Reader;
            % start decode
            jimg = im2java2d(img);
            source = BufferedImageLuminanceSource(jimg);
            bitmap = BinaryBitmap(HybridBinarizer(source));
            code39Reader = Code39Reader;
            try 
                result = code39Reader.decode(bitmap);
                message = char(result.getText());
            catch e
                message = [];        
            end
            clear source;
            clear jimg;
            clear bitmap;
        end
        % decode pdf417
        function message = decode_pdf417(obj, img)
            % include java read 2D code library
            javaaddpath('.\core-3.3.0.jar');
            javaaddpath('.\javase-3.3.0.jar');
            % import required package
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*; % BinaryBitmap;
            import com.google.zxing.common.*;
            %import com.google.zxing.Result;
            import com.google.zxing.pdf417.*; % PDF417Reader;
            % start decode
            jimg = im2java2d(img);
            source = BufferedImageLuminanceSource(jimg);
            bitmap = BinaryBitmap(HybridBinarizer(source));
            pdf417Reader = PDF417Reader;
            try 
                result = pdf417Reader.decode(bitmap);
                message = char(result.getText());
            catch e
                message = [];        
            end
            clear source;
            clear jimg;
            clear bitmap;
        end
        % decode upca
        function message = decode_upca(obj, img)
            % include java read 2D code library
            javaaddpath('.\core-3.3.0.jar');
            javaaddpath('.\javase-3.3.0.jar');
            % import required package
            import com.google.zxing.client.j2se.*;
            import com.google.zxing.*;  % BinaryBitmap
            import com.google.zxing.common.*;
            %import com.google.zxing.Result;
            import com.google.zxing.oned.*; % UPCAReader
            % start decode
            jimg = im2java2d(img);
            source = BufferedImageLuminanceSource(jimg);
            bitmap = BinaryBitmap(HybridBinarizer(source));
            upcaReader = UPCAReader;
            try 
                result = upcaReader.decode(bitmap);
                message = char(result.getText());
            catch e
                message = [];        
            end
            clear source;
            clear jimg;
            clear bitmap;
        end
        % parse and save images
        function obj = parseAndSaveImagesWithUPCA(obj, msg, topViewImage, sideViewImage)
            obj.csNumber = msg(1:5);
            csString = strcat('CS', msg(1:5));
            obj.repNumber = msg(6:7);
            repString = strcat('Rep', msg(6:7));
            obj.roundNumber = msg(8:9);
            roundString = strcat('Round', msg(8:9));
            obj.trayNumber = msg(10:11);
            trayString = strcat('Tray', msg(10:11));
            if(isempty(obj.experimentName) && isempty(obj.savePath))
                outputPath = strcat('C:', obj.seperator, 'Users', obj.seperator, 'Public', obj.seperator, 'Documents', ...
                                    obj.seperator, 'Image_data', obj.seperator, 'Unknown_Experiment_Name', ...
                                    obj.seperator, roundString, obj.seperator, repString, ...
                                    obj.seperator, csString, obj.seperator, datestr(now,'yyyy-mm-dd'), obj.seperator);
            elseif(isempty(obj.experimentName))
                outputPath = strcat(obj.savePath, obj.seperator, 'Unknown_Experiment_Name', ...
                                    obj.seperator, roundString, obj.seperator, repString, ...
                                    obj.seperator, csString, obj.seperator, datestr(now,'yyyy-mm-dd'), obj.seperator);

            elseif(isempty(obj.savePath))
                outputPath = strcat('C:', obj.seperator, 'Users', obj.seperator, 'Public', obj.seperator, 'Documents', ...
                                    obj.seperator, 'Image_data', obj.seperator, obj.experimentName, ...
                                    obj.seperator, roundString, obj.seperator, repString, ...
                                    obj.seperator, csString, obj.seperator, datestr(now,'yyyy-mm-dd'), obj.seperator);
            else
                outputPath = strcat(obj.savePath, obj.seperator, obj.experimentName, ...
                                    obj.seperator, roundString, obj.seperator, repString, ...
                                    obj.seperator, csString, obj.seperator, datestr(now,'yyyy-mm-dd'), obj.seperator);
            end
            if(exist(outputPath, 'dir')==0)
                mkdir(outputPath);
            end
            if(isempty(obj.experimentName))
                outputPathForSideImage = strcat(outputPath, 'Unknown_Experiment_Name', '_', roundString, '_', repString, '_', csString, ...
                                                '_', datestr(now,'yyyy-mm-dd_HH-MM'), '.jpg');
            else
                outputPathForSideImage = strcat(outputPath, obj.experimentName, '_', roundString, '_', repString, '_', csString, ...
                                                '_', datestr(now,'yyyy-mm-dd_HH-MM'), '.jpg');
            end
            imwrite(topViewImage, outputPathForSideImage);
            if(isempty(obj.experimentName))
                outputPathForTopImage = strcat(outputPath, 'Unknown_Experiment_Name', '_', roundString, '_', repString, '_', csString, ...
                                                '_', datestr(now,'yyyy-mm-dd_HH-MM'), '_top.jpg');
            else
                outputPathForTopImage = strcat(outputPath, obj.experimentName, '_', roundString, '_', repString, '_', csString, ...
                                                '_', datestr(now,'yyyy-mm-dd_HH-MM'), '_top.jpg');
            end
            imwrite(sideViewImage, outputPathForTopImage);
        end
    end
    %% public methods
    methods
		%% Constructor and destructor
        % constructor
        function obj = ImageProcessor(leftSideImage, topImage, rightSideImage)
            if(strcmpi(computer,'PCWIN') || strcmpi(computer,'PCWIN64'))
                obj.seperator='\';
            elseif(strcmpi(computer,'GLNX86') || strcmpi(computer,'GLNXA86'))
                obj.seperator='/';
            elseif(strcmpi(computer,'MACI64')) 
                obj.seperator='/';
            end
			obj.leftSideImage = leftSideImage;
			obj.topImage = topImage;
			obj.rightSideImage = rightSideImage;
        end
        % destructor
        function delete(obj)
        end
		%% Set and get
		% Set left side image
		function obj = setLeftSideImage(obj, leftSideImage)
			obj.leftSideImage = leftSideImage;
		end
		% Set top image
		function obj = setTopImage(obj, topImage)
			obj.topImage = topImage;
		end
		% Set right side image
		function obj = setRightSideImage(obj, rightSideImage)
			obj.rightSideImage = rightSideImage;
        end
        % Set experiment name
        function obj = setExperimentName(obj, experimentName)
            if(isnumeric(experimentName))
                obj.experimentName = num2str(experimentName);
            elseif(ischar(experimentName))
                obj.experimentName = experimentName;
            end
        end
        % Set round number
        function obj = setRoundNumber(obj, roundNumber)
            if(isnumeric(roundNumber))
                obj.roundNumber = num2str(roundNumber);
            elseif(ischar(roundNumber))
                obj.roundNumber = roundNumber;
            end
        end
        % Set tray number
        function obj = setTrayNumber(obj, trayNumber)
            if(isnumeric(trayNumber))
                obj.trayNumber = num2str(trayNumber);
            elseif(ischar(trayNumber))
                obj.trayNumber = trayNumber;
            end
        end
        % set save path
        function obj = setSavePath(obj, savePath)
            if(isnumeric(savePath))
                obj.savePath = num2str(savePath);
            elseif(ischar(savePath))
                obj.savePath = savePath;
            end
        end
		%% Cropping images
		% Left Cam Crop --- imcrop(Image, [xmin ymin width height])
		function [image_sframe1, image_sframe2, image_sframe3, image_sframe4] = leftCamCrop(obj)
			image_sframe1 = imcrop(obj.leftSideImage,[300 0 1000 2764]);
			image_sframe2 = imcrop(obj.leftSideImage,[1150 0 1000 2764]);
			image_sframe3 = imcrop(obj.leftSideImage,[2100 0 1000 2764]);
			image_sframe4 = imcrop(obj.leftSideImage,[2870 0 1000 2764]);
			obj.image_sframe1 = image_sframe1;
			obj.image_sframe2 = image_sframe2;
			obj.image_sframe3 = image_sframe3;
			obj.image_sframe4 = image_sframe4;
		end
		% Top Cam Crop --- imcrop(Image, [xmin ymin width height])
		function [image_stframe5, image_stframe6, image_stframe7, image_stframe8, image_stframe9, image_stframe10, image_stframe11, image_stframe12] = topCamCrop(obj)
			image_stframe5 = imcrop(obj.topImage,[2400 1 1000 1380]);
			image_stframe6 = imcrop(obj.topImage,[1700 1 1000 1380]);
			image_stframe7 = imcrop(obj.topImage,[950 1 1000 1380]);
			image_stframe8 = imcrop(obj.topImage,[200 1 1000 1380]);
			image_stframe9 = imcrop(obj.topImage,[200 1380 1000 1380]);
			image_stframe10 = imcrop(obj.topImage,[950 1380 1000 1380]);
			image_stframe11 = imcrop(obj.topImage,[1700 1380 1000 1380]);
			image_stframe12 = imcrop(obj.topImage,[2400 1380 1000 1380]);
			obj.image_stframe5 = image_stframe5;
			obj.image_stframe6 = image_stframe6;
			obj.image_stframe7 = image_stframe7;
			obj.image_stframe8 = image_stframe8;
			obj.image_stframe9 = image_stframe9;
			obj.image_stframe10 = image_stframe10;
			obj.image_stframe11 = image_stframe11;
			obj.image_stframe12 = image_stframe12;
		end
		% Right Cam Crop --- imcrop(Image, [xmin ymin width height])
		function [image_sframe13, image_sframe14, image_sframe15, image_sframe16] = rightCamCrop(obj)
			image_sframe13 = imcrop(obj.rightSideImage,[200 0 1000 2764]);
			image_sframe14 = imcrop(obj.rightSideImage,[1000 0 1000 2764]);
			image_sframe15 = imcrop(obj.rightSideImage,[1900 0 1000 2764]);
			image_sframe16 = imcrop(obj.rightSideImage,[2870 0 1000 2764]);
			obj.image_sframe13 = image_sframe13;
			obj.image_sframe14 = image_sframe14;
			obj.image_sframe15 = image_sframe15;
			obj.image_sframe16 = image_sframe16;
        end
        %% Scan 1D or 2D code
        % scan UPC-A
        function obj = scanUPCA(obj)
            obj.clearMsgSeqFields();
            % get barcodes
            for a=1200:100:2000
                for b=2600:100:2700
                    for c=1:100:501
                        for d=800:100:1000
                            if isempty(obj.msg1)
                                obj.seq1 = obj.seq1 + 1;
                                disp(['no obj.msg1: ', num2str(obj.seq1), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg1 = obj.decode_upca(obj.image_sframe1(a:b, c:d, :));
                                disp(['obj.msg1: ', obj.msg1]);
                            end
                            if isempty(obj.msg2)
                                obj.seq2 = obj.seq2 + 1;
                                disp(['no obj.msg2: ', num2str(obj.seq2), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg2 = obj.decode_upca(obj.image_sframe2(a:b, c:d, :));
                                disp(['obj.msg2: ', obj.msg2]);
                            end
                            if isempty(obj.msg3)
                                obj.seq3 = obj.seq3 + 1;
                                disp(['no obj.msg3: ', num2str(obj.seq3), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg3 = obj.decode_upca(obj.image_sframe3(a:b, c:d, :));
                                disp(['obj.msg3: ', obj.msg3]);
                            end
                            if isempty(obj.msg4)
                                obj.seq4 = obj.seq4 + 1;
                                disp(['no obj.msg4: ', num2str(obj.seq4), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg4 = obj.decode_upca(obj.image_sframe4(a:b, c:d, :));
                                disp(['obj.msg4: ', obj.msg4]);
                            end
                            if isempty(obj.msg5)
                                obj.seq5 = obj.seq5 + 1;
                                disp(['no obj.msg5: ', num2str(obj.seq5), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg5 = obj.decode_upca(obj.image_sframe13(a:b, c:d, :));
                                disp(['obj.msg5: ', obj.msg5]);
                            end
                            if isempty(obj.msg6)
                                obj.seq6 = obj.seq6 + 1;
                                disp(['no obj.msg6: ', num2str(obj.seq6), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg6 = obj.decode_upca(obj.image_sframe14(a:b, c:d, :));
                                disp(['obj.msg6: ', obj.msg6]);
                            end
                            if isempty(obj.msg7)
                                obj.seq7 = obj.seq7 + 1;
                                disp(['no obj.msg7: ', num2str(obj.seq7), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg7 = obj.decode_upca(obj.image_sframe15(a:b, c:d, :));
                                disp(['obj.msg7: ', obj.msg7]);
                            end
                            if isempty(obj.msg8)
                                obj.seq8 = obj.seq8 + 1;
                                disp(['no obj.msg8: ', num2str(obj.seq8), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg8 = obj.decode_upca(obj.image_sframe16(a:b, c:d, :));
                                disp(['obj.msg8: ', obj.msg8]);
                            end
                        end
                    end
                end
            end
        end
        % scan Aztec
        function obj = scanAztec(obj)
            obj.clearMsgSeqFields();
            % get barcodes
            for a=1200:100:2000
                for b=2600:100:2700
                    for c=1:100:501
                        for d=800:100:1000
                            if isempty(obj.msg1)
                                obj.seq1 = obj.seq1 + 1;
                                disp(['no obj.msg1: ', num2str(obj.seq1), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg1 = obj.decode_aztec(obj.image_sframe1(a:b, c:d, :));
                                disp(['obj.msg1: ', obj.msg1]);
                            end
                            if isempty(obj.msg2)
                                obj.seq2 = obj.seq2 + 1;
                                disp(['no obj.msg2: ', num2str(obj.seq2), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg2 = obj.decode_aztec(obj.image_sframe2(a:b, c:d, :));
                                disp(['obj.msg2: ', obj.msg2]);
                            end
                            if isempty(obj.msg3)
                                obj.seq3 = obj.seq3 + 1;
                                disp(['no obj.msg3: ', num2str(obj.seq3), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg3 = obj.decode_aztec(obj.image_sframe3(a:b, c:d, :));
                                disp(['obj.msg3: ', obj.msg3]);
                            end
                            if isempty(obj.msg4)
                                obj.seq4 = obj.seq4 + 1;
                                disp(['no obj.msg4: ', num2str(obj.seq4), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg4 = obj.decode_aztec(obj.image_sframe4(a:b, c:d, :));
                                disp(['obj.msg4: ', obj.msg4]);
                            end
                            if isempty(obj.msg5)
                                obj.seq5 = obj.seq5 + 1;
                                disp(['no obj.msg5: ', num2str(obj.seq5), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg5 = obj.decode_aztec(obj.image_sframe13(a:b, c:d, :));
                                disp(['obj.msg5: ', obj.msg5]);
                            end
                            if isempty(obj.msg6)
                                obj.seq6 = obj.seq6 + 1;
                                disp(['no obj.msg6: ', num2str(obj.seq6), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg6 = obj.decode_aztec(obj.image_sframe14(a:b, c:d, :));
                                disp(['obj.msg6: ', obj.msg6]);
                            end
                            if isempty(obj.msg7)
                                obj.seq7 = obj.seq7 + 1;
                                disp(['no obj.msg7: ', num2str(obj.seq7), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg7 = obj.decode_aztec(obj.image_sframe15(a:b, c:d, :));
                                disp(['obj.msg7: ', obj.msg7]);
                            end
                            if isempty(obj.msg8)
                                obj.seq8 = obj.seq8 + 1;
                                disp(['no obj.msg8: ', num2str(obj.seq8), ' a b c d ', num2str(a), ' ', num2str(b), ' ', num2str(c), ' ', num2str(d)]);
                                obj.msg8 = obj.decode_aztec(obj.image_sframe16(a:b, c:d, :));
                                disp(['obj.msg8: ', obj.msg8]);
                            end
                        end
                    end
                end
            end
        end
		%% Save images
        % save images using upca
        function obj = saveImagesUsingUPCA(obj)
            if(~isempty(obj.msg1))
                if(isnumeric(obj.msg1))
                    obj.msg1 = num2str(obj.msg1);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg1, obj.image_sframe1, obj.image_stframe5);
            end
            if(~isempty(obj.msg2))
                if(isnumeric(obj.msg2))
                    obj.msg2 = num2str(obj.msg2);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg2, obj.image_sframe2, obj.image_stframe6);
            end
            if(~isempty(obj.msg3))
                if(isnumeric(obj.msg3))
                    obj.msg3 = num2str(obj.msg3);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg3, obj.image_sframe3, obj.image_stframe7);
            end
            if(~isempty(obj.msg4))
                if(isnumeric(obj.msg4))
                    obj.msg4 = num2str(obj.msg4);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg4, obj.image_sframe4, obj.image_stframe8);
            end
            if(~isempty(obj.msg5))
                if(isnumeric(obj.msg5))
                    obj.msg5 = num2str(obj.msg5);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg5, obj.image_sframe13, obj.image_stframe9);
            end
            if(~isempty(obj.msg6))
                if(isnumeric(obj.msg6))
                    obj.msg6 = num2str(obj.msg6);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg6, obj.image_sframe14, obj.image_stframe10);
            end
            if(~isempty(obj.msg7))
                if(isnumeric(obj.msg7))
                    obj.msg7 = num2str(obj.msg7);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg7, obj.image_sframe15, obj.image_stframe11);
            end
            if(~isempty(obj.msg8))
                if(isnumeric(obj.msg8))
                    obj.msg8 = num2str(obj.msg8);
                end
                obj = obj.parseAndSaveImagesWithUPCA(obj.msg8, obj.image_sframe16, obj.image_stframe12);
            end
        end
    end
end
