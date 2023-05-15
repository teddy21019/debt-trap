// Name:        Seadragon.Seadragon.Config.debug.js
// Assembly:    AjaxControlToolkit
// Version:     4.1.7.725
// FileVersion: 4.1.7.0725
// (c) 2010 CodePlex Foundation
Type.registerNamespace('Sys.Extended.UI.Seadragon');
Type.registerNamespace('Seadragon');
Sys.Extended.UI.Seadragon.Config = function() {

    this.debugMode = true;

    this.animationTime = 1.5;

    this.blendTime = 0.5;

    this.alwaysBlend = false;

    this.autoHideControls = true;

    this.immediateRender = false;

    this.wrapHorizontal = false;

    this.wrapVertical = false;

    this.minZoomDimension = 0.8;

    this.maxZoomPixelRatio = 2;

    this.visibilityRatio = 0.5;

    this.springStiffness = 5.0;

    this.imageLoaderLimit = 2;

    this.clickTimeThreshold = 200;

    this.clickDistThreshold = 5;

    this.zoomPerClick = 2.0;

    this.zoomPerSecond = 2.0;

    this.showNavigationControl = true;

    this.maxImageCacheCount = 100;

    this.minPixelRatio = 0.5;

    this.mouseNavEnabled = true;

    this.navImages = {
        zoomIn: {
            REST: 'WebResource.axd?d=eMrHG1THZq8V1Z2yzrUjpbTmJK6WdJRg9dwdhYO1HFDAsMbLyTIQ6hr8FyOgiPPlQby6Gvq97Gh8q7XpfqPaZRLmOCUKQKGAIjCGNu-8UOMJSYQdLSqkr_V65f438MNuZvogwBesy4a68zthlJknQA2&t=635821619998910786',
            GROUP: 'WebResource.axd?d=HGlsAY7RWGBgM_MckZEmBL2rBhOQgIOSy02TR5GID7rtn_zcqTVjkgq-EvVfoYFJUB0jRdqwZBV6JS2t6A4GfmPABI1RJfCoc3BN7VdBZKqxGOpofI1lu1VzZtrpvqAkI1IBIkTPATHxzFjnbJnV-p5rJ244fl6QpiNfB_xL0AE1&t=635821619998910786',
            HOVER: 'WebResource.axd?d=3Mcds7liOkOuQG6PCSbneifL0Bh68_EBk8JtjYpyTDY7P95ZpccqXztaNCwWaz-te3yjUNFlcIA1FtR_f9LJjOns0WtUtx_NwWtOlmHIIzqdB28BzqVRYe5nSBv_onXeAlrzJ0Sc11T5KNR1XPCXIA2&t=635821619998910786',
            DOWN: 'WebResource.axd?d=oDDjlnHxRqDm349EaZaFdNPG9WCxERfA9tNCffT-wf41oY-dsU6QtZbPeUj1Lg-EmAbE5gNDDZYhSSq1XhDkD_ueUX9ZlHZvJ9sLFgnEuQHGtgM0fuOplHiSx5Y5bJ4sznCmOkydv6aiPK9vHTmGCg2&t=635821619998910786'
        },
        zoomOut: {
            REST: 'WebResource.axd?d=Rhz04shUAVggOMLzMvTcmHTDDARqRQubws7t0mRQycfkBZic_PratQoJoMpqE1AZu0BxHc99nV3nuhup12JsOH2eGmSlH0oWDBFu3qd9x51CH-isttGovkVERkvPLRNjhxKB5rhYmkxnC41DEncU_Q2&t=635821619998910786',
            GROUP: 'WebResource.axd?d=5TECfCHeE-XavST1RzMleLCFPG5s9mDD6G9XsxCoAvEbfF_IuN5iL49XnOl3VWCuJ8WI5jv3xh-DoNwGYXrCyxGOwdS53uXBJHMEkcWgXZa3pt44KcHFXP8qWTjarUSUKHq24U9dOP_6QFc93CWAl_VcBjtPl5x-rpUrr8valaQ1&t=635821619998910786',
            HOVER: 'WebResource.axd?d=C5lyj60g3PbYIQZ_j38igl6CLZtr0jnOJAx9dw5M8mhAT6-dx07-lx6CDp-NJy7sxhcoLZdHOEiIPgqYPnwYRtHF5UmFVKSSIjOQTUX_VoaKTk6JM-gtq5c3_7DfpNJGxDrSHChIW7XRBHSEDMQDIg2&t=635821619998910786',
            DOWN: 'WebResource.axd?d=RsRFndTY8n0sbL019K6xRj59XYY9M7lV7fMqNAeq7a7bir_o5U4xnQGlaayCa2JNV7B1dwCuWMbzDrHpUmGs2aaqtwJj8eqLIHlR_FvnH24_FV_ocj5r8U-lW70wMLefXGeP43loebwjDqEYUiz9zQJgQCOgfGENog6KWcWrNB01&t=635821619998910786'
        },
        home: {
            REST: 'WebResource.axd?d=xjrFaH9W9_B0QlC1U7xzs5eYTf_9ePe_pHzdfm8GCeOl2_sQorEodv6zPbaQ-Ned13ZRx1-BGLra_lMXUVUK2Gtrzo13jrxwxPMl5B0MOcEgdi8r3X2459SB2kbPD-CpvYBfihrWBjy_PkudLmAMSw2&t=635821619998910786',
            GROUP: 'WebResource.axd?d=oxhmiTr-R9KQNaOKegpJLPqdIJo4yvMFa4eUpP8xCfs4F2Eh7G-oVorrGNWJG5r_eI9d4Ip6yq4eseZ_WaLIQxkJD9ZO8XsojAFGRfUvnxM_YzbNrgtOEqT9rkBliP-LWowqUXQO0y0_2VbPd0261J7CNLm6zTyIXEmQBZPsvvQ1&t=635821619998910786',
            HOVER: 'WebResource.axd?d=YCTNwnDWUoa3m88LtC6R7dahp9lul-MGwh-1bofruR-WOsGV5TuibovHOGyZvwIO8xiw13_UNa2OJJGyfm-0r6PCZyJEsSSBpzxWdSOfqbdJScIZIhQpjFWs_ltDZkTXOBSLJuPD3YYr34SSZZwoow2&t=635821619998910786',
            DOWN: 'WebResource.axd?d=xdghwZO7qMFCkRYIWSAHeWF_b8J6xLfeLll5iIWHisWDfNhzYMPBPGdWadmMJTZZamK5hjiO2v_-y-Mvbls_Kje-OxrBajT_lL96Ywkmf8eTHtpQESbcy3yiWGKzhNAJpJ-UZ_JBh3cdlQ5dKw_Y0A2&t=635821619998910786'
        },
        fullpage: {
            REST: 'WebResource.axd?d=GPrQ36ZztO9dAaMCq0PwZGm51N-KBhAUVwA8JmCy_noWGImRZCyGO0A04rpdJZ1V8qgSh6vordlaQPwn8pgGr_5HCUgOUyH5QPcfxLZtXh5UigCC0EeaSwfWlREjfcM8Ue6rM1wJDqr9SZQuN_0YOg2&t=635821619998910786',
            GROUP: 'WebResource.axd?d=26qV16WoZShRbnYdsd_U1jwmyfGH2J_08IHx5OAY0FMti84n8yn8A8bJp6mbVxd2HvRVMLTiH2rmx9U7VY9-ff71MJExSHSON9fArR5mBQRDScN7125INYx3R9h2UGa_bVigBDUWJ0XDES47H4P288JFVtRBfqB2hY-fLgNp2oA1&t=635821619998910786',
            HOVER: 'WebResource.axd?d=3iLYk-mu-LilLl8_PZgoChacKV2_PP4-z-h2VB4x8W3Im4OJ6-PgAdEXDNNFVxvWLcbSsFk3F9Ir9s-y__5Q_2O5CnhOhxWa6o-Vc-Nv4l_u1XVa0AVYUMfp-VMw-WkxhXF29EIen6_qVxE3-ABdjg2&t=635821619998910786',
            DOWN: 'WebResource.axd?d=2j9ghYlEJbwb_Trw-44DmRt_lnvSbnqsLeXYppcQDgMmtp-Ng-qEA-BHLoJjopk0iZFh6bWhRtnj94P4tX4_ZOpYlqcvXQ78UOj2fkFQuHrjpgZou8GD5dOoop0mDJ2D5ixzt3Z6j3hQxRVLQw3pSRS-aef7F95oGmMT2eq3fdM1&t=635821619998910786'
        }
    };
};
Sys.Extended.UI.Seadragon.Config.registerClass('Sys.Extended.UI.Seadragon.Config', null, Sys.IDisposable);
