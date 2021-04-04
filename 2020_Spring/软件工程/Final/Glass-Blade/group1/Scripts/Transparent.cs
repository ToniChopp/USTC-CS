//Author: wmj

//nothing
/*
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//Only a Example
//merged into CharacterBehavior
public class Transparent : MonoBehaviour
{
    Renderer[] renderers;
    // Start is called before the first frame update
    void Start()
    {
        Shader shader = Shader.Find("Transparent/Diffuse");
        renderers = GetComponentsInChildren<Renderer>();
        foreach(var render in renderers)
        {
            render.material.shader = shader;
        }
        SetTransparent(1f);
    }

    public void SetTransparent(float a)
    {
        foreach (var render in renderers)
        {
            render.material.color = new Color(1f, 1f, 1f, a);
        }
    }
}
*/