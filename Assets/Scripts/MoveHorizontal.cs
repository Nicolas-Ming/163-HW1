﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveHorizontal : MonoBehaviour
{
    Vector3 tempPos;
    float direction = 1;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.x  > 5)
        {
            direction = direction * -1;
        }
        if(transform.position.x < -5)
        {
            direction = direction * -1;
        }
        transform.Translate(.2f * direction,0f,0f);
    }
}