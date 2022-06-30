<template>
    <div class="teamStatus" :class="{'bot-substitution-intent': botSubstitutionIntent}">

        <!-- <img :src="logoUrl" alt="team logo" class="team-logo"/> -->

        <div class="cards">
            <Card class="card" color="red" :num-cards="team.redCards" />
            <Card class="card" color="yellow" :num-cards="team.yellowCards" />
            <!-- <BotCount class="card" :num-bots="team.maxAllowedBots"/> -->
        </div>

        <div class="team-name">
            <div :class="{'team-yellow': color === 'yellow', 'team-blue': color === 'blue'}" class="team-color"></div>
            <div class="team-name-text">{{team.name}}</div>
        </div>
        <!-- <div class="cardTimers">
                <span v-for="(cardTime, index) in team.yellowCardTimes.slice(0,3)" :key="index">
                <CardTimer :cardTimer="cardTime" />
                </span>
        </div> -->
    </div>
</template>

<script>
    import {Referee} from "@/sslProto"
    import teamLogoUrl from "@/teamLogoUrl"
    import Card from "./Card";
    // import CardTimer from "./CardTimer";
    // import BotCount from "@/components/BotCount";

    export default {
        name: "TeamStatus",
        components: {Card},
        props: {
            color: String,
            team: Referee.ITeamInfo,
        },
        computed: {
            logoUrl() {
                return teamLogoUrl(this.team.name);
            },
            botSubstitutionIntent() {
                return this.team.botSubstitutionIntent;
            }
        }
    }
</script>

<style scoped>

    .cards {
        display: flex;
        width: 100%;
        flex-basis: 50%;
        justify-content: center;
        align-items: center;
    }

    .card {
    }

    .teamStatus {
        display: flex;
        flex-direction: column;
        width: 100%;
        padding: 1vmin;
        transition: background-color 500ms ease;
    }

    .bot-substitution-intent {
            background-color: #c2c3d0;
    }

    .team-color {
        width: 40px;
        height: 40px;
        margin-left: 5px;
        margin-right: 5px;
        border-radius: 100%;
    }

    .team-name {
        width: 100%;
        display: flex;
        justify-content: center;
        flex-basis: 50%;
        font-size: 1.1em;
    }

    .team-logo {
        max-width: 60%;
    }

    .cardTimers {
        margin-top: 6px;
        display: block;
    }

</style>
