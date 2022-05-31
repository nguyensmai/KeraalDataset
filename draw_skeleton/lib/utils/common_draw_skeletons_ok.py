import cv2
from enum import Enum


class CocoPart(Enum):
    Nose = 0
    Neck = 1
    RShoulder = 2
    RElbow = 3
    RWrist = 4
    LShoulder = 5
    LElbow = 6
    LWrist = 7
    RHip = 8
    RKnee = 9
    RAnkle = 10
    LHip = 11
    LKnee = 12
    LAnkle = 13
    REye = 14
    LEye = 15
    REar = 16
    LEar = 17
    Background = 18


class Human:
    """
    body_parts: list of BodyPart
    """
    __slots__ = ('body_parts', 'pairs', 'uidx_list', 'score')

    def __init__(self, pairs):
        self.pairs = []
        self.uidx_list = set()
        self.body_parts = {}
        for pair in pairs:
            self.add_pair(pair)
        self.score = 0.0

    @staticmethod
    def _get_uidx(part_idx, idx):
        return '%d-%d' % (part_idx, idx)

    def add_pair(self, pair):
        self.pairs.append(pair)
        self.body_parts[pair.part_idx1] = BodyPart(Human._get_uidx(pair.part_idx1, pair.idx1),
                                                   pair.part_idx1,
                                                   pair.coord1[0], pair.coord1[1], pair.score)
        self.body_parts[pair.part_idx2] = BodyPart(Human._get_uidx(pair.part_idx2, pair.idx2),
                                                   pair.part_idx2,
                                                   pair.coord2[0], pair.coord2[1], pair.score)
        self.uidx_list.add(Human._get_uidx(pair.part_idx1, pair.idx1))
        self.uidx_list.add(Human._get_uidx(pair.part_idx2, pair.idx2))

    def is_connected(self, other):
        return len(self.uidx_list & other.uidx_list) > 0

    def merge(self, other):
        for pair in other.pairs:
            self.add_pair(pair)

    def part_count(self):
        return len(self.body_parts.keys())

    def get_max_score(self):
        return max([x.score for _, x in self.body_parts.items()])

    def get_face_box(self, img_w, img_h, mode=0):
        """
        Get Face box compared to img size (w, h)
        :param img_w:
        :param img_h:
        :param mode:
        :return:
        """
        # SEE : https://github.com/ildoonet/tf-pose-estimation/blob/master/tf_pose/common.py#L13
        _NOSE = CocoPart.Nose.value
        _NECK = CocoPart.Neck.value
        _REye = CocoPart.REye.value
        _LEye = CocoPart.LEye.value
        _REar = CocoPart.REar.value
        _LEar = CocoPart.LEar.value

        _THRESHOLD_PART_CONFIDENCE = 0.2
        parts = [part for idx, part in self.body_parts.items() if part.score > _THRESHOLD_PART_CONFIDENCE]

        is_nose, part_nose = _include_part(parts, _NOSE)
        if not is_nose:
            return None

        size = 0
        is_neck, part_neck = _include_part(parts, _NECK)
        if is_neck:
            size = max(size, img_h * (part_neck.y - part_nose.y) * 0.8)

        is_reye, part_reye = _include_part(parts, _REye)
        is_leye, part_leye = _include_part(parts, _LEye)
        if is_reye and is_leye:
            size = max(size, img_w * (part_reye.x - part_leye.x) * 2.0)
            size = max(size,
                       img_w * math.sqrt((part_reye.x - part_leye.x) ** 2 + (part_reye.y - part_leye.y) ** 2) * 2.0)

        if mode == 1:
            if not is_reye and not is_leye:
                return None

        is_rear, part_rear = _include_part(parts, _REar)
        is_lear, part_lear = _include_part(parts, _LEar)
        if is_rear and is_lear:
            size = max(size, img_w * (part_rear.x - part_lear.x) * 1.6)

        if size <= 0:
            return None

        if not is_reye and is_leye:
            x = part_nose.x * img_w - (size // 3 * 2)
        elif is_reye and not is_leye:
            x = part_nose.x * img_w - (size // 3)
        else:  # is_reye and is_leye:
            x = part_nose.x * img_w - size // 2

        x2 = x + size
        if mode == 0:
            y = part_nose.y * img_h - size // 3
        else:
            y = part_nose.y * img_h - _round(size / 2 * 1.2)
        y2 = y + size

        # fit into the image frame
        x = max(0, x)
        y = max(0, y)
        x2 = min(img_w - x, x2 - x) + x
        y2 = min(img_h - y, y2 - y) + y

        if _round(x2 - x) == 0.0 or _round(y2 - y) == 0.0:
            return None
        if mode == 0:
            return {"x": _round((x + x2) / 2),
                    "y": _round((y + y2) / 2),
                    "w": _round(x2 - x),
                    "h": _round(y2 - y)}
        else:
            return {"x": _round(x),
                    "y": _round(y),
                    "w": _round(x2 - x),
                    "h": _round(y2 - y)}

    def get_upper_body_box(self, img_w, img_h):
        """
        Get Upper body box compared to img size (w, h)
        :param img_w:
        :param img_h:
        :return:
        """

        if not (img_w > 0 and img_h > 0):
            raise Exception("img size should be positive")

        _NOSE = CocoPart.Nose.value
        _NECK = CocoPart.Neck.value
        _RSHOULDER = CocoPart.RShoulder.value
        _LSHOULDER = CocoPart.LShoulder.value
        _THRESHOLD_PART_CONFIDENCE = 0.3
        parts = [part for idx, part in self.body_parts.items() if part.score > _THRESHOLD_PART_CONFIDENCE]
        part_coords = [(img_w * part.x, img_h * part.y) for part in parts if
                       part.part_idx in [0, 1, 2, 5, 8, 11, 14, 15, 16, 17]]

        if len(part_coords) < 5:
            return None

        # Initial Bounding Box
        x = min([part[0] for part in part_coords])
        y = min([part[1] for part in part_coords])
        x2 = max([part[0] for part in part_coords])
        y2 = max([part[1] for part in part_coords])

        # # ------ Adjust heuristically +
        # if face points are detcted, adjust y value

        is_nose, part_nose = _include_part(parts, _NOSE)
        is_neck, part_neck = _include_part(parts, _NECK)
        torso_height = 0
        if is_nose and is_neck:
            y -= (part_neck.y * img_h - y) * 0.8
            torso_height = max(0, (part_neck.y - part_nose.y) * img_h * 2.5)
        #
        # # by using shoulder position, adjust width
        is_rshoulder, part_rshoulder = _include_part(parts, _RSHOULDER)
        is_lshoulder, part_lshoulder = _include_part(parts, _LSHOULDER)
        if is_rshoulder and is_lshoulder:
            half_w = x2 - x
            dx = half_w * 0.15
            x -= dx
            x2 += dx
        elif is_neck:
            if is_lshoulder and not is_rshoulder:
                half_w = abs(part_lshoulder.x - part_neck.x) * img_w * 1.15
                x = min(part_neck.x * img_w - half_w, x)
                x2 = max(part_neck.x * img_w + half_w, x2)
            elif not is_lshoulder and is_rshoulder:
                half_w = abs(part_rshoulder.x - part_neck.x) * img_w * 1.15
                x = min(part_neck.x * img_w - half_w, x)
                x2 = max(part_neck.x * img_w + half_w, x2)

        # ------ Adjust heuristically -

        # fit into the image frame
        x = max(0, x)
        y = max(0, y)
        x2 = min(img_w - x, x2 - x) + x
        y2 = min(img_h - y, y2 - y) + y

        if _round(x2 - x) == 0.0 or _round(y2 - y) == 0.0:
            return None
        return {"x": _round((x + x2) / 2),
                "y": _round((y + y2) / 2),
                "w": _round(x2 - x),
                "h": _round(y2 - y)}

    def __str__(self):
        return ' '.join([str(x) for x in self.body_parts.values()])

    def __repr__(self):
        return self.__str__()

def draw_humans(npimg, humans, imgcopy=False):
    image_h, image_w = npimg.shape[:2]
    centers = {}
    for human in humans:
        # draw point
        for i in range(CocoPart.Background.value):
            if i not in human.body_parts.keys():
                continue

            body_part = human.body_parts[i]
            center = (int(body_part.x * image_w + 0.5), int(body_part.y * image_h + 0.5))
            centers[i] = center
            cv2.circle(npimg, center, 3, CocoColors[i], thickness=3, lineType=8, shift=0)

        # draw line
        for pair_order, pair in enumerate(CocoPairsRender):
            if pair[0] not in human.body_parts.keys() or pair[1] not in human.body_parts.keys():
                continue

            # npimg = cv2.line(npimg, centers[pair[0]], centers[pair[1]], common.CocoColors[pair_order], 3)
            cv2.line(npimg, centers[pair[0]], centers[pair[1]], CocoColors[pair_order], 3)

    return npimg
    
class BodyPart:
    """
    part_idx : part index(eg. 0 for nose)
    x, y: coordinate of body part
    score : confidence score
    """
    __slots__ = ('uidx', 'part_idx', 'x', 'y', 'score')

    def __init__(self, uidx, part_idx, x, y, score):
        self.uidx = uidx
        self.part_idx = part_idx
        self.x, self.y = x, y
        self.score = score

    def get_part_name(self):
        return CocoPart(self.part_idx)

    def __str__(self):
        return 'BodyPart:%d-(%.2f, %.2f) score=%.2f' % (self.part_idx, self.x, self.y, self.score)

    def __repr__(self):
        return self.__str__()
        
CocoColors_pairs_vc = {(0,2):[225,105,65] , (1,3):[225,105,65] , (0,7):[255, 144, 30] , (1,8):[255,0,0] , (13,15):[255, 144, 30] , (13,16):[255, 144, 30], (15,11):[255, 144, 30] , (12,16):[255,0,0] , (14,4):[255, 144, 30] , (9,10):[255, 144, 30] , (10,11):[255, 144, 30] , (0,12):[255, 144, 30] , (12,13):[255, 144, 30] , (13,14):[238,104,123] , (14,15):[238,104,123] , (0,16):[255, 144, 30] , (16,17):[255, 144, 30] , (17,18):[255, 144, 30] , (18,19):[255, 144, 30] , (3,4):[255, 144, 30] , (1,8):[255, 144, 30] , (1,11):[255, 144, 30] , (11,12):[255, 144, 30] , (14,8):[255, 144, 30] , (0,14):[248, 131, 121] , (14,7):[240, 128, 128] , (0,15):[254, 111, 94] , (15,17):[226, 114, 91],(7,2):[226, 114, 91],(8,3):[226, 114, 91],(0,2):[226, 114, 91],(1,3):[226, 114, 91],(0,9):[226, 114, 91],(1,10):[226, 114, 91],(14,4):[226, 114, 91],(4,13):[226, 114, 91],(4,5):[226, 114, 91],(4,6):[226, 114, 91],(5,15):[226, 114, 91],(6,16):[226, 114, 91]}

CocoColors_parts_vc = {0:[255,191,0] , 1:[255,191,0] , 2:[255,191,0] , 3:[255,191,0] , 4:[255,191,0] , 5:[255,191,0] , 6:[255,191,0] , 7:[255,191,0] , 8:[255,191,0] , 9:[255, 127, 0] , 10:[255, 127, 0] , 11:[255,191,0] , 12:[255, 144, 30] , 13:[255, 144, 30] , 14:[0, 127, 255] , 15:[255, 144, 30] , 16:[255, 144, 30] , 17:[255, 144, 30] , 18:[255, 144, 30] , 19:[255, 144, 30] , 20:[255, 144, 30] , 21:[255, 144, 30] , '(0,1)':[255, 140, 105] , '(0,1)':[255, 127, 80] , '(0,1)':[250, 128, 114] , '(0,1)':[248, 131, 121] , '(0,1)':[240, 128, 128] , '(0,1)':[254, 111, 94] , '(0,1)':[226, 114, 91]}     


CocoColors_pairs_vc = {(0,2):[225,105,65] , (1,3):[225,105,65] , (0,7):[255, 144, 30] , (1,8):[255,0,0] , (13,15):[255, 144, 30] , (13,16):[255, 144, 30], (15,11):[255, 144, 30] , (12,16):[255,0,0] , (14,4):[255, 144, 30] , (9,10):[255, 144, 30] , (10,11):[255, 144, 30] , (0,12):[255, 144, 30] , (12,13):[255, 144, 30] , (13,14):[238,104,123] , (14,15):[238,104,123] , (0,16):[255, 144, 30] , (16,17):[255, 144, 30] , (17,18):[255, 144, 30] , (18,19):[255, 144, 30] , (3,4):[255, 144, 30] , (1,8):[255, 144, 30] , (1,11):[255, 144, 30] , (11,12):[255, 144, 30] , (14,8):[255, 144, 30] , (0,14):[248, 131, 121] , (14,7):[240, 128, 128] , (0,15):[254, 111, 94] , (15,17):[226, 114, 91],(7,2):[226, 114, 91],(8,3):[226, 114, 91],(0,2):[226, 114, 91],(1,3):[226, 114, 91],(0,9):[226, 114, 91],(1,10):[226, 114, 91],(14,4):[226, 114, 91],(4,13):[226, 114, 91],(4,5):[226, 114, 91],(4,6):[226, 114, 91],(5,15):[226, 114, 91],(6,16):[226, 114, 91]}

CocoColors_parts_vc = {0:[255,191,0] , 1:[255,191,0] , 2:[255,191,0] , 3:[255,191,0] , 4:[255,191,0] , 5:[255,191,0] , 6:[255,191,0] , 7:[255,191,0] , 8:[255,191,0] , 9:[255, 127, 0] , 10:[255, 127, 0] , 11:[255,191,0] , 12:[255, 144, 30] , 13:[255, 144, 30] , 14:[0, 127, 255] , 15:[255, 144, 30] , 16:[255, 144, 30] , 17:[255, 144, 30] , 18:[255, 144, 30] , 19:[255, 144, 30] , 20:[255, 144, 30] , 21:[255, 144, 30] , '(0,1)':[255, 140, 105] , '(0,1)':[255, 127, 80] , '(0,1)':[250, 128, 114] , '(0,1)':[248, 131, 121] , '(0,1)':[240, 128, 128] , '(0,1)':[254, 111, 94] , '(0,1)':[226, 114, 91]}


CocoColors_pairs_vc = {(0,2):[35,137,58] , (1,3):[35,137,58] , (0,7):[35,137,58] , (1,8):[35,137,58] , (13,15):[35,137,58] , (13,16):[35,137,58], (15,11):[35,137,58] , (12,16):[35,137,58] , (14,4):[35,137,58] , (9,10):[35,137,58] , (10,11):[35,137,58] , (0,12):[35,137,58] , (12,13):[35,137,58] , (13,14):[35,137,58] , (14,15):[35,137,58] , (0,16):[35,137,58] , (16,17):[35,137,58] , (17,18):[35,137,58] , (18,19):[35,137,58] , (3,4):[35,137,58] , (1,8):[35,137,58] , (1,11):[35,137,58] , (11,12):[35,137,58] , (14,8):[35,137,58] , (0,14):[35,137,58] , (14,7):[35,137,58] , (0,15):[116, 245, 190] , (15,17):[35,137,58],(7,2):[35,137,58],(8,3):[35,137,58],(0,2):[35,137,58],(1,3):[35,137,58],(0,9):[35,137,58],(1,10):[35,137,58],(14,4):[35,137,58],(4,13):[35,137,58],(4,5):[35,137,58],(4,6):[35,137,58],(5,15):[35,137,58],(6,16):[35,137,58]}

CocoColors_parts_vc = {0:[56,253,158] , 1:[56,253,158] , 2:[56,253,158] , 3:[56,253,158] , 4:[56,253,158] , 5:[56,253,158] , 6:[56,253,158] , 7:[56,253,158] , 8:[56,253,158] , 9:[35,137,58] , 10:[255, 127, 0] , 11:[56,253,158] , 12:[35,137,58] , 13:[35,137,58] , 14:[35,137,58] , 15:[35,137,58] , 16:[35,137,58] , 17:[35,137,58] , 18:[35,137,58] , 19:[35,137,58] , 20:[35,137,58] , 21:[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58] , '(0,1)':[35,137,58]}
     
              
CocoColors_pairs = {(0,100):[0, 128, 255] , (0,1):[0,165,255] , (1,2):[71,99,255] , (2,3):[80,127,255] , (2,4):[0,140,255] , (4,5):[224,255,255] , (5,6):[80,127,255] , (6,7):[128, 231, 251] , (2,8):[182, 228, 255] , (8,9):[196, 228, 255] , (9,10):[173, 222, 255] , (10,11):[185, 218, 255] , (0,12):[180, 229, 255] , (12,13):[173, 222, 255] , (13,14):[153, 204, 255] , (14,15):[0,165,255] , (0,17):[0,165,255] , (17,18):[0,165,255] , (18,19):[136, 189, 255] , (1,5):[71,99,255] , (3,4):[128, 231, 251] , (1,8):[0,165,255] , (1,11):[0,165,255] , (11,12):[196, 228, 255] , (1,0):[0,165,255] , (0,14):[0,165,255] , (14,16):[0,165,255] , (0,15):[0,165,255] , (15,17):[0,165,255]}

CocoColors_parts = {0:[0, 128, 255] , 1:[0,69,255] , 2:[71,99,255] , 3:[80,127,255] , 4:[0,140,255] , 5:[71,99,255] , 6:[80,127,255] , 7:[0,140,255] , 8:[182, 228, 255] , 9:[196, 228, 255] , 10:[164, 203, 255] , 11:[185, 218, 255] , 12:[180, 229, 255] , 13:[164, 203, 255] , 14:[153, 204, 255] , 15:[153, 204, 255] , 16:[177, 206, 251] , 17:[177, 206, 251] , 18:[136, 189, 255] , 19:[244, 164, 96] , 20:[255, 160, 122] , 21:[233, 150, 122] , '(0,1)':[255, 140, 105] , '(0,1)':[255, 127, 80] , '(0,1)':[250, 128, 114] , '(0,1)':[248, 131, 121] , '(0,1)':[240, 128, 128] , '(0,1)':[254, 111, 94] , '(0,1)':[226, 114, 91]}

CocoColors_pairs_kn = {(0,1):[225,105,65] , (1,2):[225,105,65] , (2,3):[255, 144, 30] , (2,4):[255,0,0] , (4,5):[255, 144, 30] , (5,6):[255, 144, 30], (6,7):[255, 144, 30] , (2,8):[255,0,0] , (8,9):[255, 144, 30] , (9,10):[255, 144, 30] , (10,11):[255, 144, 30] , (0,12):[255, 144, 30] , (12,13):[255, 144, 30] , (13,14):[238,104,123] , (14,15):[238,104,123] , (0,16):[255, 144, 30] , (16,17):[255, 144, 30] , (17,18):[255, 144, 30] , (18,19):[255, 144, 30] , (3,4):[255, 144, 30] , (1,8):[255, 144, 30] , (1,11):[255, 144, 30] , (11,12):[255, 144, 30] , (1,0):[255, 144, 30] , (0,14):[248, 131, 121] , (14,16):[240, 128, 128] , (0,15):[254, 111, 94] , (15,17):[226, 114, 91]}

CocoColors_parts_kn = {0:[255,191,0] , 1:[255,191,0] , 2:[255,191,0] , 3:[255,191,0] , 4:[255,191,0] , 5:[255,191,0] , 6:[255,191,0] , 7:[255,191,0] , 8:[255,191,0] , 9:[255,191,0] , 10:[255,191,0] , 11:[255,191,0] , 12:[255, 144, 30] , 13:[255, 144, 30] , 14:[255, 144, 30] , 15:[255, 144, 30] , 16:[255, 144, 30] , 17:[255, 144, 30] , 18:[255, 144, 30] , 19:[255, 144, 30] , 20:[255, 144, 30] , 21:[255, 144, 30] , '(0,1)':[255, 140, 105] , '(0,1)':[255, 127, 80] , '(0,1)':[250, 128, 114] , '(0,1)':[248, 131, 121] , '(0,1)':[240, 128, 128] , '(0,1)':[254, 111, 94] , '(0,1)':[226, 114, 91]}
              
              
