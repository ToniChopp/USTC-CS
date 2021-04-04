//Author:Via Cytus
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

namespace Com.Glassblade.Group1
{
    public class ShowTheResult : MonoBehaviour
    {
        private playersData[] p;
        private playersData[] p0;
        private playersData[] p1;
        private GameObject[] team0;
        private GameObject[] team1;

        void Start()
        {
            // 普通模式
            if (GameObject.Find("NData") != null)
            {
                p = GameObject.FindWithTag("Finish").GetComponentInChildren<NDataStore>().p;
            }
            // 占领模式
            else if (GameObject.Find("OData") != null)
            {
                p = GameObject.FindWithTag("Finish").GetComponentInChildren<ODataStore>().p;
            }
            // 两个队伍的初始化
            team0 = GameObject.FindGameObjectsWithTag("Team0").OrderBy(g => g.transform.GetSiblingIndex()).ToArray();
            team1 = GameObject.FindGameObjectsWithTag("Team1").OrderBy(g => g.transform.GetSiblingIndex()).ToArray();
            int i = 0;
            int j = 0;
            // 两个队伍的玩家数组
            p0 = new playersData[p.Length / 2];
            p1 = new playersData[p.Length / 2];
            for (int k = 0; k < p.Length; k ++)
            {
                if (p[k].team == 0)
                {
                    p0[i] = p[k];
                    i++;
                }
                else if (p[k].team == 1)
                {
                    p1[j] = p[k];
                    j++;
                }
            }
            // 根据得分排序
            p0.OrderBy(g => g.score);
            p1.OrderBy(g => g.score);
            // 将两队玩家的游戏结果传递出来
            for(i = 0;  i < team0.Length; i ++)
            {
                if (i < p0.Length)
                {
                    team0[i].transform.GetChild(0).GetComponentInChildren<Text>().text = p0[i].name;
                    team0[i].transform.GetChild(1).GetComponentInChildren<Text>().text = p0[i].killTime.ToString();
                    team0[i].transform.GetChild(2).GetComponentInChildren<Text>().text = p0[i].deathTime.ToString();
                    team0[i].transform.GetChild(3).GetComponentInChildren<Text>().text = p0[i].score.ToString();
                }
                else
                {
                    team0[i].SetActive(false);
                }
            }
            for (i = 0; i < team1.Length; i++)
            {
                if (i < p1.Length)
                {
                    team1[i].transform.GetChild(0).GetComponentInChildren<Text>().text = p1[i].name;
                    team1[i].transform.GetChild(1).GetComponentInChildren<Text>().text = p1[i].killTime.ToString();
                    team1[i].transform.GetChild(2).GetComponentInChildren<Text>().text = p1[i].deathTime.ToString();
                    team1[i].transform.GetChild(3).GetComponentInChildren<Text>().text = p1[i].score.ToString();
                }
                else
                {
                    team1[i].SetActive(false);
                }
            }
            // 普通模式的结果结算
            if (GameObject.Find("NData") != null)
            {
                int allKill0 = 0;
                int allKill1 = 0;
                foreach(playersData g in p0)
                {
                    allKill0 += g.killTime;
                }
                foreach (playersData g in p1)
                {
                    allKill1 += g.killTime;
                }
                switch(allKill0<allKill1)
                {
                    case true: GameObject.Find("Title").GetComponentInChildren<Text>().text = "失败";
                        AudioSource music;
                        music = transform.GetComponentsInChildren<AudioSource>()[1];
                        music.Play(); break;
                    case false: GameObject.Find("Title").GetComponentInChildren<Text>().text = (allKill0 == allKill1) ? "平局" : "胜利";
                        music = transform.GetComponentsInChildren<AudioSource>()[0];
                        music.Play(); break;
                }
            }
            // 占点模式的结果结算
            else if (GameObject.Find("OData") != null)
            {
                switch (GameObject.Find("OData").GetComponentInChildren<ODataStore>().score0 < GameObject.Find("OData").GetComponentInChildren<ODataStore>().score1)
                {
                    case true: GameObject.Find("Title").GetComponentInChildren<Text>().text = "失败";
                        AudioSource music;
                        music = transform.GetComponentsInChildren<AudioSource>()[1];
                        music.Play(); break;
                    case false: GameObject.Find("Title").GetComponentInChildren<Text>().text = (GameObject.Find("OData").GetComponentInChildren<ODataStore>().score0 == GameObject.Find("OData").GetComponentInChildren<ODataStore>().score1) ? "平局" : "胜利";
                        music = transform.GetComponentsInChildren<AudioSource>()[0];
                        music.Play(); break;
                }
            }
        }


        void Update()
        {

        }
    }
}