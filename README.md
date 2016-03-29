# AutoXOA - compile / install Xen Orchestra from source

## Purpose

The AutoXOA project installs and configures [Xen Orchestra](https://xen-orchestra.com/#!/) from source. The purpose is to automate the procedure for developer environments and home lab use.

![AutoXOA Install Menu](https://raw.githubusercontent.com/hackmods/autoXOA/master/autoinstall/images/InstallMenu.pmg)

## Instructions

To set up AutoXOA, all you need is a Debian install or variant such as Ubuntu. First install curl. Execute the preceding curl command to retrieve and run the autoXOA script.

Install curl
```
Apt-get install curl
```

Run the AutoXOA script
```
curl -L autoXOA.zxcv.us | bash
```

And thats it! The default installation is in /xoa/. Preceding instalation, you can start the XO-server package from the autoXOA script. The script is installed in /xoa/autoXOA.sh.

![AutoXOA Install Menu](https://raw.githubusercontent.com/hackmods/autoXOA/master/autoinstall/images/StartXOA.pmg)

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
