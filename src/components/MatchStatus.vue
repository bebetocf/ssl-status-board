<template>
    <div class="match-status">
        <div class="time-box">
            <div class="stage">{{stage}}</div>

            <div class="time-container" v-format-us-duration="refereeMessage.stageTimeLeft"
                :class="{'time-positive': refereeMessage.stageTimeLeft >= 0, 'time-negative': refereeMessage.stageTimeLeft < 0}">
            </div>
        </div>
        <div class="score-box">
            <div
                :class="{'highlight-command': true, 'stop-command': isStop, 'halt-command': isHalt, 'robot-substitution': isRobotSubstitution}">

                <div class="score">
                    {{refereeMessage.yellow.score}} : {{refereeMessage.blue.score}}
                </div>
            </div>

            <!-- <hr class="separator"/> -->

            <div class="command-box">
                <div :class="{'team-yellow': commandForYellow, 'team-blue': commandForBlue}" class="team-color"></div>
                
                <div class="command">
                    {{gameState}}
                    <span v-if="isBallPlacement && remainingTime >= 0">
                        (<span v-format-us-duration="remainingTime"></span>)
                    </span>
                    <span v-if="isTimeout">
                        (<span v-format-us-duration="timeoutTime"></span>)
                    </span>
                </div>

            </div>

            <!-- <PowerPlay/> -->

        </div>
    </div>
</template>

<script>
    import {Referee, GameEvent} from "@/sslProto"
    import {mapStageToText, mapCommandToText} from "@/texts";

    export default {
        name: "MatchStatus",
        computed: {
            refereeMessage() {
                return this.$store.state.refereeMsg;
            },
            isHalt() {
                return !this.isRobotSubstitution && this.refereeMessage.command === Referee.Command.HALT;
            },
            isStop() {
                return !this.isRobotSubstitution && this.refereeMessage.command === Referee.Command.STOP;
            },
            isRobotSubstitution() {
                if (this.refereeMessage.command !== Referee.Command.HALT) {
                    return false;
                }
                for(const gameEvent of this.refereeMessage.gameEvents) {
                    if (gameEvent.type === GameEvent.Type.BOT_SUBSTITUTION) {
                        return true;
                    }
                }
                return false;
            },
            stage() {
                return mapStageToText(this.refereeMessage.stage);
            },
            gameState() {
                if (this.isRobotSubstitution) {
                    return "Robot Substitution"
                }
                return mapCommandToText(this.refereeMessage.command);
            },
            isBallPlacement() {
                return this.refereeMessage.command === Referee.Command.BALL_PLACEMENT_BLUE ||
                    this.refereeMessage.command === Referee.Command.BALL_PLACEMENT_YELLOW;
            },
            remainingTime() {
                return this.refereeMessage.currentActionTimeRemaining;
            },
            isTimeout() {
                return this.refereeMessage.command === Referee.Command.TIMEOUT_BLUE ||
                    this.refereeMessage.command === Referee.Command.TIMEOUT_YELLOW;
            },
            timeoutTime() {
                if (this.refereeMessage.command === Referee.Command.TIMEOUT_BLUE) {
                    return this.refereeMessage.blue.timeoutTime;
                } else if (this.refereeMessage.command === Referee.Command.TIMEOUT_YELLOW) {
                    return this.refereeMessage.yellow.timeoutTime;
                }
                return 0;
            },
            commandForBlue() {
                switch (this.refereeMessage.command) {
                    case Referee.Command.PREPARE_KICKOFF_BLUE:
                    case Referee.Command.PREPARE_PENALTY_BLUE:
                    case Referee.Command.DIRECT_FREE_BLUE:
                    case Referee.Command.INDIRECT_FREE_BLUE:
                    case Referee.Command.TIMEOUT_BLUE:
                    case Referee.Command.GOAL_BLUE:
                    case Referee.Command.BALL_PLACEMENT_BLUE:
                        return true;
                }
                return false;
            },
            commandForYellow() {
                switch (this.refereeMessage.command) {
                    case Referee.Command.PREPARE_KICKOFF_YELLOW:
                    case Referee.Command.PREPARE_PENALTY_YELLOW:
                    case Referee.Command.DIRECT_FREE_YELLOW:
                    case Referee.Command.INDIRECT_FREE_YELLOW:
                    case Referee.Command.TIMEOUT_YELLOW:
                    case Referee.Command.GOAL_YELLOW:
                    case Referee.Command.BALL_PLACEMENT_YELLOW:
                        return true;
                }
                return false;
            }
        }
    }
</script>

<style scoped>

    .match-status {
        display: flex;
        flex-direction: column;
        height: 100%;
        align-items: center;
    }

    .time-box {
        display: flex;
        align-items: stretch;
        width: 100%;
    }

    .time-container {
        color: white;
        width: fit-content;
        flex-basis: 50%;
        padding: 0.1em;
        margin: 0.1em;
    }

    .time-positive {
        background-color: transparent;
    }

    .time-negative {
        background-color: transparent;
    }

    .separator {
        margin: 0.2em;
    }

    .score-box {
        display: flex;
        flex-direction: column;
        width: 100%;
    }

    .score {
        width: 100%;
        flex-basis: 100%;
        white-space: nowrap;
        font-size: 2em;
        color: white;
    }

    .stage {
        width: fit-content;
        flex-basis: 50%;
        padding: 0.1em;
        margin: 0.1em;
    }

    .command-box {
        justify-content: center;
        display: flex;
    }

    .team-color {
        width: 40px;
        height: 40px;
        margin-left: 5px;
        display: inline-block;
        margin-right: 5px;
        border-radius: 100%;
    }

    .command {
        width: fit-content;
        justify-content: center;
        font-size: 1.1em;
    }

    .highlight-command {
        display: flex;
        align-items: stretch;
        border-radius: .5em;
        padding: 0.2em 0.1em 0.1em;
        margin-top: 0.1em;
    }

</style>
