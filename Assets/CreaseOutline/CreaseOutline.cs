using System;
using UnityEngine;

namespace Nothke.CreaseOutline
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class CreaseOutline : PostEffectsBase
    {
        public Shader multShader = null;
        private Material multMaterial = null;

        //public RenderTexture r2t;
        RenderTexture RT;
        public Camera renderCamera;

        public Color outlineColor;

        public override bool CheckResources()
        {
            CheckSupport(false);

            multMaterial = CheckShaderAndCreateMaterial(multShader, multMaterial);
            //multMaterial.SetTexture("_MultTex", r2t);
            multMaterial.SetColor("_OutlineColor", outlineColor);

            if (!isSupported)
                ReportAutoDisable();
            return isSupported;
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (CheckResources() == false)
            {
                Graphics.Blit(source, destination);
                return;
            }

            int rtW = source.width;
            int rtH = source.height;

            if (!RT)
            {
                RT = new RenderTexture(rtW, rtH, 0);
                multMaterial.SetTexture("_MultTex", RT);
                renderCamera.targetTexture = RT;
            }

            Graphics.Blit(source, destination, multMaterial);

            /*
            RenderTexture.ReleaseTemporary(hrTex);
            RenderTexture.ReleaseTemporary(lrTex1);*/
        }
    }
}
