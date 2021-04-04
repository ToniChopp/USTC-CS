// Author: wmj
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace Com.Glassblade.Group1
{
    /// <summary>
    /// 人物死亡的事件，在OCharacterBehavior中实例化
    /// </summary>
    public class DeathEvent : UnityEvent<OCharacterBehavior>
    {
    }
}