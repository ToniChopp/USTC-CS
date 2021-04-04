//Author: David Wang
//Function: To show countdown time, component of Canvas/Information/CountDown
//Todo:Add Canvas to the scene, then add Information.prefab,add this script in CountDown
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

namespace Com.Glassblade.Group1
{
    public class CountDown : MonoBehaviour
    {
        // 最大时间
        public int minute=8;
        // 游戏剩余时间
        private int getTime;
        // 计帧
        private float timer = 0;
        //时间文本
        public Text countTimeText;

        void Awake()
        {
            /*实例化玩家组件列表
            Players = GameObject.FindGameObjectsWithTag("Player");
            //不销毁对象
            for (int i = 0; i < Players.Length; i++)
            {
                DontDestroyOnLoad(Players[i]);
            }*/
        }

        void Start()
        {
            //获取游戏剩余时间
            getTime = 60 * minute;
            //获取时间文本组件
            countTimeText = GetComponentInChildren<Text>();
        }

        void Update()
        {
            //转换场景
            if (getTime==0)
            {
                GameObject.FindWithTag("Finish").GetComponentInChildren<NDataStore>().Refresh();
                SceneManager.LoadSceneAsync("ending");
            }
            //获取分钟
            int M = getTime / 60;
            //获取秒
            int S = getTime % 60;
            //帧数加
            timer += Time.deltaTime;
            //满一秒
            if (timer >= 1f)
            {
                //清零
                timer = 0;
                //剩余时间-1
                getTime --;
                //设置时间文本
                countTimeText.text = M + ":" + string.Format("{0:00}",S);
            }
        }
    }
}