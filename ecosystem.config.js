module.exports = {
  "apps": [
        {
            "name": "docs",
            "cwd": "D:\\nowtech-docs\\",
            //"script": "node_modules/.bin/docusaurus.cmd",
            "script": "C:\\Program Files\\nodejs\\node_modules\\npm\\bin\\npm-cli.js",
            "args": "start --no-browser",
            "exec_mode": "cluster",
            "instances": 1,
            "interpreter": "none"
        }
    ],
};
