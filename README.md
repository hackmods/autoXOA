# AutoXOA - compile / install Xen Orchestra from source

### For Xen Server 7.X

This branch is developed to work with Xen Server 7.X, developed on XenServer 7. The script will grab the latest versions of XOA-server and XOA-web. For legacy XenServer 6.X users the new web module still should work. IF legacy support is needed for XenServer 6.X check out [branch Version-6.X](https://github.com/hackmods/autoXOA/tree/Version-6.X).

## Purpose

The AutoXOA project installs and configures [Xen Orchestra](https://xen-orchestra.com/#!/) from source. The purpose is to automate the procedure for developer environments and home lab use.

![AutoXOA Install Menu](https://raw.githubusercontent.com/hackmods/autoXOA/master/images/InstallMenu.png)

## Instructions

To set up AutoXOA, all you need is a Debian install or variant such as Ubuntu. First install curl. Execute the preceding curl command to retrieve and run the autoXOA script.

Install curl
```
apt-get install curl
```

Run the AutoXOA script
```
curl -L autoXOA.zxcv.us | bash
```

And thats it! The default installation is in /xoa/. Preceding instalation, you can start the XO-server package from the autoXOA script. The script is installed in /xoa/autoXOA.sh.


If you are running this on a minimal install, whiptail also needs to be installed.
```
apt-get install whiptail
```

If you are running on Ubuntu, you must run it under sudo -i for the bash script to function.
```
sudo -i curl -L autoXOA.zxcv.us | bash
```

![AutoXOA Install Menu](https://raw.githubusercontent.com/hackmods/autoXOA/master/images/startXOA.PNG)


### For development builds

Run the DevAutoXOA script
```
curl -L DevAutoXOA.zxcv.us | bash
```

## Goals
### General
* Support auto updating of XOA via NPM
* Allow for branch switching between stable and development builds

### Tasks

#### Stage 1
- [x] Build a prototype layout.
- [x] Gather commands for installation from source.
- [x] Write curl script to run tasks automatically.
- [x] Complete autopilot install.
- [ ] Develop automatic updates.

#### Stage 2
- [ ] Configure static ip addressing.
- [ ] Enable service starting on boot.
- [ ] Supress output from sever [run in  background]
- [ ] Build a community portal feedback website.
- [ ] Release preconfigured image.

## Questions:

There are currently no questions.

## License
Copyright [2016] [Ryan Morris]

Licensed under the GNU General Public License v3.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either  express or implied. See the License for the specific language governing permissions and limitations under the License.
