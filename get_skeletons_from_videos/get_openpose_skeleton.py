import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable
from collections import OrderedDict
from scipy.ndimage.morphology import generate_binary_structure
from scipy.ndimage.filters import gaussian_filter, maximum_filter
from lib.network.rtpose_vgg import get_model 
from lib.network import im_transform
from evaluate.coco_eval import get_outputs, handle_paf_and_heat
from lib.utils.common import Human, BodyPart, CocoPart, CocoColors, CocoPairsRender, draw_humans
from lib.utils.paf_to_pose import paf_to_pose_cpp
from lib.config import cfg, update_config
from torchsummary import summary
from evaluate.coco_eval import get_outputs, handle_paf_and_heat, run_eval
from numpngw import write_apng


####Update the variables space.###############################
sys.path.append('.'); 




###########NETWORK CONFIG ############
class Namespace:
  def __init__(self, **kwargs):
    self.__dict__.update(kwargs)

# update config file
args = Namespace(cfg = './experiments/vgg19_368x368_sgd.yaml', weight = 'pose_model.pth', opts = [])
update_config(cfg, args)


###Model extraction

device = torch.device("cpu")
model = get_model('vgg19')   
model.load_state_dict(torch.load(args.weight))
model = torch.nn.DataParallel(model).to(device)
model.float()
model.eval()
print('model evaluated')


#Init data parameters and json folder structure

filename=sys.argv[1]
images =[]
tab={}
tab1={}
tab1['positions']=tab
data={'positions':{}}

Video_file_path=sys.argv[1]
filename=Video_file_path
print(Video_file_path)
output_folder='/'.join(Video_file_path.replace(Video_file_path.split('/')[-2],Video_file_path.split('/')[-2]+'_openpose_json').split('/')[:-1])
print('output_file')
output_file=output_folder+'/'+Video_file_path.split('/')[-1]
print(output_file)
print(output_folder)
os.system('mkdir '+output_folder )

# identify the patient
def identify_patient(humans):
        num_persons=len(humans)
        print(range(0,len(humans)))
        for i in range(0,len(humans)):
             print(i)
             human=humans[i]
             for j in human.body_parts.keys():
                 print((human.body_parts[j].part_idx,human.body_parts[j].x,human.body_parts[j].y))
                 persons.append((i,float(human.body_parts[j].x)))
                 print("done!")
        patient_indice=sorted(persons,key=lambda x: x[1])[-1][0]
        patient_indice=patient_indice
        return patient_indice




Body_parts={0:'Nose',1:'Neck',2:'rShoulder',3:'rElbow',4:'rWrist',5:'lShoulder',6:'lElbow',7:'lWrist',8:'rHip',9:'rKnee',10:'rAnkle',11:'lHip',12:'lKnee',13:'lAnkle',14:'rEye', 15:'lEye',16:'rEar', 17:'lEar'}


#capture the video frames
video_capture = cv2.VideoCapture(filename)


print('start reading video')
while video_capture.isOpened(): 
        data_keypoints={}
        persons=[]
        frame_number=video_capture.get(cv2.CAP_PROP_POS_FRAMES)+1
        tab[str(frame_number)]={}
        # Capture frame-by-frame
        is_success, oriImg = video_capture.read()
        print("step1")
        if not is_success:
            print('broke')
            break
        
        shape_dst = np.min(oriImg.shape[0:2])

        with torch.no_grad():
            paf, heatmap, imscale = get_outputs(
                oriImg, model, 'rtpose')
        
        print(type(paf))
        print(type(heatmap))
        print(type(imscale))
        humans = paf_to_pose_cpp(heatmap, paf, cfg)
        for human in humans:
              for i in human.body_parts.keys():
                   print((human.body_parts[i].part_idx,human.body_parts[i].x,human.body_parts[i].y))
        patient_indice=identify_patient(humans)
        for i in humans[patient_indice].body_parts.keys():
                child={Body_parts_0[humans[patient_indice].body_parts[i].part_idx]:[humans[patient_indice].body_parts[i].x,humans[patient_indice].body_parts[i].y]}
                tab[str(frame_number)].update(child)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # When everything is done, release the capture
print(tab1)
with open(output_file+".json", "w") as f:
    json.dump(tab1, f, indent=4, sort_keys=False)
f.close()
video_capture.release()
cv2.destroyAllWindows()
sys.exit(0)

