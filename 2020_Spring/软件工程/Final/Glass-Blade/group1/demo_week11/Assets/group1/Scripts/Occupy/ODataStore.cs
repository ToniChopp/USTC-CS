// Author: Via Cytus
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Com.Glassblade.Group1
{
    public class ODataStore : MonoBehaviour
    {
        // 玩家数据
        public playersData[] p;
        public static ODataStore instance;
        public int score0;
        public int score1;

        void Awake()
        {
            DontDestroyOnLoad(gameObject);
            instance = this;
        }

        public void Refresh()
        {
            //玩家组件列表
            GameObject[] Players = null;
            //实例化玩家组件列表
            Players = GameObject.FindGameObjectsWithTag("Player");
            p = new playersData[Players.Length];
            for (int i=0;i<Players.Length;i++)
            {
                p[i].name = Players[i].transform.GetChild(6).GetComponentInChildren<TextMesh>().text;
                p[i].killTime = Players[i].GetComponentInChildren<OCharacterBehavior>().killTime;
                p[i].deathTime = Players[i].GetComponentInChildren<OCharacterBehavior>().deathTime;
                p[i].score = Players[i].GetComponentInChildren<OCharacterBehavior>().score;
                p[i].team = Players[i].GetComponentInChildren<OCharacterBehavior>().team;
            }
            score0 = GameObject.Find("A Score").GetComponentInChildren<OScoreIncrease>().score;
            score1 = GameObject.Find("B Score").GetComponentInChildren<OScoreIncrease>().score;
        }
    }
}