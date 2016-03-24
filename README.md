# AutoXOA - compile / install Xen Orchestra from source

## Purpose

The AutoXOA project seeks to install [Xen Orchestra](https://xen-orchestra.com/#!/) from source. The purpose is to automate the procedure for developer environments and home lab use.

![alt tag](https://raw.githubusercontent.com/bradgillap/Informeshion/master/images/install.png)

## Instructions

Instructions are simple, net install the latest version of Debian.

Install curl
Apt-get install curl

Run the AutoXOA script
curl -L autoXOA.zxcv.us | bash

## Goals
### General
* Install XOA from source
* Support auto updating of XOA via NPM
* Allow for branch switching between stable and development builds

### Tasks

#### Stage 1
- [x] Build a prototype layout. 
- [x] Gather commands for installation from source.
- [ ] Write curl script to run tasks automatically.
- [ ] Develop automatic updates

#### Stage 2
- [ ] Bash script the prototype for consumption with curl by the community.
- [ ] Build a community portal feedback website.
- [ ] Release preconfigured images.

## Questions:

There are currently no questions.

## License
Copyright [2016] [Ryan Morris]

Licensed under the GNU General Public License v3.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either  express or implied. See the License for the specific language governing permissions and limitations under the License.
