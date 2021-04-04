// Author: David Wang
// Function: 显示夺取倒计时，倒计时结束夺取成功，显示"✔"
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Com.Glassblade.Group1
{
    public class CircleCountDownDisplay : MonoBehaviour
    {
        // 调用占点模式
        public OMode OM;
        // 最大时间
        private float max;
        // 当前时间
        private float current;
        // 占领的队伍
        private int? tempTeam;
        // 占领结果
        private int? teamResult;
        // 整个倒计时牌
        public RectTransform CircleCountDown;
        // 提示文字，倒计时时间
        public RectTransform Indicator;
        // 外圈
        public RectTransform Circle;

        // David Wang add 占点可视
        // 相机位置
        private Transform camPosition;
        // 占点在相机中的位置
        private Vector3 viewPos;
        // 相机到点的向量
        private Vector3 camToDot;


        // 初始化赋值
        void Start()
        {
            max = (float)OM.occupyCountDown;
            current = max;
            tempTeam = null;
            teamResult = null;
            CircleCountDown.GetComponent<CanvasGroup>().alpha = 0;
        }

        // 
        void Update()
        {
            current = OM.currentTime;
            tempTeam = OM.tempTeam;
            teamResult = OM.team;

            // David Wang add 占点可视
            // 获取相机位置
            camPosition = Camera.main.transform;
            // 将占点的点三维坐标转化成屏幕坐标
            viewPos = Camera.main.WorldToScreenPoint(OM.transform.position);
            // 计算相机到点的向量值
            camToDot = (OM.transform.position - camPosition.position).normalized;
            float dot = Vector3.Dot(camPosition.forward, camToDot);
            // 点在屏幕内
            if (dot > 0 && (viewPos.x > 0 && viewPos.x < 1980) && (viewPos.y > 0 && viewPos.y < 1020))
            {
                // 如果点在屏幕内，且位置足以放下倒计时圆盘
                if (viewPos.x > 80 && viewPos.x < 1900 && viewPos.y > 80 && viewPos.y < 940)
                {
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 点在左边界
                else if (viewPos.x <= 80 && viewPos.y > 80 && viewPos.y < 940)
                {
                    viewPos.x = 80;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 点在右边界
                else if (viewPos.x >= 1900 && viewPos.y > 80 && viewPos.y < 940)
                {
                    viewPos.x = 1900;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 点在下边界
                else if (viewPos.x > 80 && viewPos.x < 1900 && viewPos.y <= 80)
                {
                    viewPos.y = 80;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 点在上边界
                else if (viewPos.x > 80 && viewPos.x < 1900 && viewPos.y >= 940)
                {
                    viewPos.y = 940;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 左下角
                else if (viewPos.x <= 80 && viewPos.y <= 80)
                {
                    viewPos.x = 80;
                    viewPos.y = 80;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 左上角
                else if (viewPos.x <= 80 && viewPos.y >= 940)
                {
                    viewPos.x = 80;
                    viewPos.y = 940;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                // 右下角
                else if (viewPos.x >= 1900 && viewPos.y <= 80)
                {
                    viewPos.x = 1900;
                    viewPos.y = 80;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                else if (viewPos.x >= 1900 && viewPos.y >= 940)
                {
                    viewPos.x = 1900;
                    viewPos.y = 940;
                    viewPos.z = 0;
                    CircleCountDown.position = viewPos;
                }
                CircleCountDown.GetComponent<CanvasGroup>().alpha = 1;
            }

            // 0队用红色标注
            if (tempTeam == 0)
            {
                if(tempTeam != teamResult)
                {
                    Circle.GetComponent<Image>().fillAmount = current/max;
                    Circle.GetComponent<Image>().color = Color.red;
                    Indicator.GetComponent<Text>().text = ((int)current).ToString();
                    Indicator.GetComponent<Text>().color = Color.red;
                }
                // 倒计时完成，占领或者标注该点已经被玩家占领
                if (current <= 0)
                {
                    Indicator.GetComponent<Text>().text = "✔";
                }
            }
            // 1队用蓝色标注
            if (tempTeam == 1)
            {
                if(tempTeam != teamResult)
                {
                    Circle.GetComponent<Image>().fillAmount = current/max;
                    Circle.GetComponent<Image>().color = Color.blue;
                    Indicator.GetComponent<Text>().text = ((int)current).ToString();
                    Indicator.GetComponent<Text>().color = Color.blue;
                }
                // 倒计时完成，占领或者标注该点已经被玩家占领
                if (current <= 0)
                {
                    Indicator.GetComponent<Text>().text = "✔";
                }
            }
        }
    }
}
