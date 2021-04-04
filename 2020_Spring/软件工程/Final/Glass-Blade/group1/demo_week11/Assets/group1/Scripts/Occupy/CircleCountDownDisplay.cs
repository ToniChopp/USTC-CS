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
        public Transform CircleCountDown;
        // 提示文字，倒计时时间
        public Transform Indicator;
        // 外圈
        public Transform Circle;

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
            // 0队用红色标注
            if (tempTeam == 0)
            {
                if(tempTeam != teamResult)
                {
                    CircleCountDown.GetComponent<CanvasGroup>().alpha = 1;
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
                    CircleCountDown.GetComponent<CanvasGroup>().alpha = 1;
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
            if (tempTeam == null)
            {
                CircleCountDown.GetComponent<CanvasGroup>().alpha = 0;
            }
        }
    }
}
