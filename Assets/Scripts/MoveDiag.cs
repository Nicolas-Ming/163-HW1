using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveDiag : MonoBehaviour
{
    Vector3 tempPos;
    float xdirection = 1;
    float zdirection = 1;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.x > 5)
        {
            xdirection = xdirection * -1;
        }
        if (transform.position.x < -5)
        {
            xdirection = xdirection * -1;
        }
        if (transform.position.z > 0)
        {
            zdirection = zdirection * -1;
        }
        if (transform.position.z < -10)
        {
            zdirection = zdirection * -1;
        }
        transform.Translate(.2f * xdirection, 0f, .2f * zdirection);
    }
}
