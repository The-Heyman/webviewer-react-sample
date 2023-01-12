import React, { useRef, useEffect } from 'react';
import WebViewer from '@pdftron/webviewer';
import './App.css';

// user this link to try to disable modal popup and toggle it to true programmatically https://www.pdftron.com/api/web/UI.html#openElements__anchor
const App = () => {
  const viewer = useRef(null);
  var filename = "blank.pdf";
  const url = new URL(window.location.href);
  const dvlanguage = url.searchParams.get('dvlanguage');
  const subscribed = url.searchParams.get('subscribed');
  const trafficfromapp = url.searchParams.get('trafficfromapp');
  const key = "";

  // if using a class, equivalent of componentDidMount 
  useEffect(() => {
    WebViewer(
      {
        path: '/webviewer/lib',
        initialDoc: '/files/pdf.pdf',
        enableFilePicker: true,
        fullAPI: true,
        preloadWorker: WebViewer.WorkerTypes.CONTENT_EDIT,
        licenseKey: key,
      },
      viewer.current,
    ).then((instance) => {
      instance.UI.enableFeatures([instance.Feature.ContentEdit]);
      instance.Core.documentViewer.setToolMode(instance.Core.documentViewer.getTool(instance.Tools.ToolNames.CONTENT_EDIT));
      const { documentViewer } = instance.Core;
      //const contentEditManager = documentViewer.getContentEditManager();
      //contentEditManager.startContentEditMode();

      instance.UI.setLanguage(dvlanguage);
      if (subscribed !== "1") {
        documentViewer.setWatermark({
          // Draw diagonal watermark in middle of the document
          diagonal: {
            fontSize: 25, // or even smaller size
            fontFamily: 'sans-serif',
            color: 'red',
            opacity: 15, // from 0 to 100
            text: 'PDF Translator & Editor'
          }
        });
      }
      instance.UI.setHeaderItems(header => {
        const newheader = header.getItems();
        newheader.splice(0, 2);
        const uploadButton = {
          type: 'actionButton',
          img: 'icon-header-file-picker-line',
          title: 'File Picker',
          onClick: () => {
            instance.iframeWindow.document.getElementById('file-picker').click();
          },
          dataElement: 'filePickerButton',
          hidden: []
        }
        const downloadButton = {
          type: 'actionButton',
          img: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><defs><style>.cls-1{fill:#abb0c4;}</style></defs><title>icon - header - download</title><path class="cls-1" d="M11.55,17,5.09,9.66a.6.6,0,0,1,.45-1H8.67V2.6a.6.6,0,0,1,.6-.6h5.46a.6.6,0,0,1,.6.6V8.67h3.13a.6.6,0,0,1,.45,1L12.45,17A.6.6,0,0,1,11.55,17ZM3.11,20.18V21.6a.4.4,0,0,0,.4.4h17a.4.4,0,0,0,.4-.4V20.18a.4.4,0,0,0-.4-.4h-17A.4.4,0,0,0,3.11,20.18Z"></path></svg>',
          title: 'Download',
          onClick: () => {
            const options = {
              filename: filename,
            };
            instance.UI.downloadPdf(options);
          },
          dataElement: 'downloadButton',
          hidden: []
        }
        newheader.splice(1, 0, uploadButton, downloadButton);

      });
    });
  }, []);

  return (
    <div className="App">
      <div className="header"></div>
      <div className="webviewer" ref={viewer}></div>
    </div>
  );
};

export default App;
